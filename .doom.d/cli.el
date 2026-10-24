(unless (personal-config-has-profile 'aot) (advice-add #'native-compile-async :override #'ignore))

;;; Safe upgrade — supply chain safety buffer
;; Drop-in replacement for `doom upgrade` that only checks out commits
;; aged past a buffer period, giving the community time to catch malicious changes.

(defun kvwu/safe-upgrade--git (&rest args)
  "Run Git with ARGS, returning output or reporting a failure."
  (cl-destructuring-bind (status . output)
      (apply #'doom-call-process "git" args)
    (unless (eq status 0)
      (user-error "git %s failed (%s):\n%s"
                  (string-join args " ") status output))
    output))

(defun kvwu/safe-upgrade--working-tree-dirty-p (dir)
  "Return list of dirty files in DIR, or nil if clean."
  (let ((default-directory dir))
    ;; Submodules are synchronized separately after checking out core.
    (split-string (kvwu/safe-upgrade--git
                   "status" "--porcelain" "-uno" "--ignore-submodules=all")
                  "\n" t)))

(defvar kvwu/upgrade-buffer-days 14
  "Number of days to delay Doom upgrades for supply chain safety.")

(defcli! ((safe-upgrade su))
    ((buffer-days ("--buffer-days" days) "Days to delay (default: 14)")
     (dry-run?    ("--dry-run") "Show what would happen without making changes")
     (no-sync?    ("--no-sync") "Skip 'doom sync -u' after upgrading core")
     (aot?        ("--aot") "Natively compile packages ahead-of-time")
     (jobs        ("-j" "--jobs" num) "CPUs for native compilation")
     (nobuild?    ("-B") "Don't rebuild packages when hostname or Emacs version has changed")
     &context context)
  "Upgrade Doom with a time buffer for supply chain safety.

Like 'doom upgrade', but only checks out commits that have aged past
the buffer period (default: 14 days). After updating core, automatically
runs 'doom sync -u' to update packages (use --no-sync to skip).

  $ doom safe-upgrade                    # upgrade to latest commit >=14 days old
  $ doom su --buffer-days 7              # use a shorter buffer
  $ doom safe-upgrade --dry-run          # preview without changes
  $ doom safe-upgrade --no-sync          # update core only, skip package sync"
  (require 'doom-packages)
  (when (and buffer-days
             (not (string-match-p "\\`[0-9]+\\'" buffer-days)))
    (user-error "--buffer-days must be a non-negative integer"))
  (catch 'safe-upgrade-done
    (let* ((default-directory doom-emacs-dir)
           (days (if buffer-days (string-to-number buffer-days) kvwu/upgrade-buffer-days))
           (cutoff-time (time-subtract (current-time) (days-to-time days)))
           (cutoff-str (format-time-string "%Y-%m-%d" cutoff-time))
           (current-rev (kvwu/safe-upgrade--git "rev-parse" "HEAD"))
           (current-date (kvwu/safe-upgrade--git "log" "-1" "--format=%ai" "HEAD"))
           ;; Detect upstream branch from origin/HEAD rather than local HEAD,
           ;; so this works even when we're in detached HEAD from a previous run
           (upstream-branch
            (string-remove-prefix
             "refs/remotes/origin/"
             (kvwu/safe-upgrade--git "symbolic-ref" "refs/remotes/origin/HEAD"))))
      (print! (start "Doom Safe Upgrade (buffer: %d days, cutoff: %s)" days cutoff-str))
      (print! (item "Current HEAD: %s (%s)" (substring current-rev 0 12) current-date))

      ;; Fetch latest
      (print! (item "Fetching from origin..."))
      (kvwu/safe-upgrade--git "fetch" "origin" "--tags")

      ;; Find target commit: most recent on origin/branch before cutoff
      (let* ((origin-ref (format "origin/%s" upstream-branch))
             (target-rev (kvwu/safe-upgrade--git
                          "rev-list" "-1" (format "--before=%s" cutoff-str)
                          origin-ref)))
        (unless (and target-rev (not (string-empty-p target-rev)))
          (print! (success "No commits found older than %d days. Nothing to do." days))
          (throw 'safe-upgrade-done nil))

        (let ((target-date (kvwu/safe-upgrade--git "log" "-1" "--format=%ai" target-rev))
              (target-msg  (kvwu/safe-upgrade--git "log" "-1" "--format=%s" target-rev))
              (latest-rev  (kvwu/safe-upgrade--git "rev-parse" origin-ref))
              (skipped     (kvwu/safe-upgrade--git
                            "rev-list" "--count"
                            (format "%s..%s" target-rev origin-ref))))
          (print! (item "Target:  %s (%s)" (substring target-rev 0 12) target-date))
          (print! (item "         %s" target-msg))
          (print! (item "Latest:  %s" (substring latest-rev 0 12)))
          (print! (item "Skipping %s newer commit(s) still in buffer" skipped))

          (when (equal current-rev target-rev)
            (print! (success "Already at target commit. Nothing to do."))
            (throw 'safe-upgrade-done nil))

          ;; Check if current is already ahead of target
          (cl-destructuring-bind (status . output)
              (doom-call-process "git" "merge-base" "--is-ancestor" target-rev current-rev)
            (cond ((eq status 0)
                   (print! (success "Current HEAD is already past target. Nothing to do."))
                   (throw 'safe-upgrade-done nil))
                  ((not (eq status 1))
                   (user-error "Failed to compare revisions:\n%s" output))))

          (if dry-run?
              (progn
                (print! (warn "[DRY RUN] Would checkout %s" (substring target-rev 0 12)))
                (print! (item "Commits that would be applied:"))
                (print! "%s" (kvwu/safe-upgrade--git
                              "--no-pager" "log" "--oneline"
                              (format "%s..%s" current-rev target-rev))))
            ;; Check for dirty working tree
            (when-let* ((dirty (kvwu/safe-upgrade--working-tree-dirty-p default-directory)))
              (user-error "Working tree is dirty. Stash or discard changes first:\n %s"
                          (string-join dirty "\n")))

            (print! (start "Checking out %s..." (substring target-rev 0 12)))
            (kvwu/safe-upgrade--git "checkout" target-rev)
            (print! (item "Updating pinned module submodules..."))
            (kvwu/safe-upgrade--git "submodule" "update" "--init" "--recursive")
            (print! (success "Doom core updated to %s" (substring target-rev 0 12)))

            ;; Show what was applied
            (print! (item "Applied commits:"))
            (print! "%s" (kvwu/safe-upgrade--git
                          "--no-pager" "log" "--oneline"
                          (format "%s..%s" current-rev target-rev)))

            ;; Restart so sync loads the newly checked-out core.
            (when (boundp 'doom-cli-loaddefs-file)
              (delete-file doom-cli-loaddefs-file))
            (if no-sync?
                (print! (success "Finished safe upgrade of Doom Emacs"))
              (print! (start "Running doom sync -u..."))
              (exit! "doom" "sync" "-u"
                     (if aot? "--aot")
                     (if nobuild? "-B")
                     (if jobs (format "--jobs=%s" jobs))))))))))
