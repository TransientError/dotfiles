(unless (personal-config-has-profile 'aot) (advice-add #'native-compile-async :override #'ignore))

;;; Safe upgrade — supply chain safety buffer
;; Drop-in replacement for `doom upgrade` that only checks out commits
;; aged past a buffer period, giving the community time to catch malicious changes.

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
  (doom-require 'doom-lib 'packages)
  (catch 'safe-upgrade-done
    (let* ((default-directory doom-emacs-dir)
           (days (if buffer-days (string-to-number buffer-days) kvwu/upgrade-buffer-days))
           (cutoff-time (time-subtract (current-time) (days-to-time days)))
           (cutoff-str (format-time-string "%Y-%m-%d" cutoff-time))
           (current-rev (cdr (sh! "git" "rev-parse" "HEAD")))
           (current-date (cdr (sh! "git" "log" "-1" "--format=%ai" "HEAD")))
           ;; Detect upstream branch from origin/HEAD rather than local HEAD,
           ;; so this works even when we're in detached HEAD from a previous run
           (upstream-branch
            (let ((ref (cdr (sh! "git" "symbolic-ref" "refs/remotes/origin/HEAD"))))
              (if (and ref (string-match "refs/remotes/origin/\\(.+\\)" ref))
                  (match-string 1 ref)
                "master"))))
      (print! (start "Doom Safe Upgrade (buffer: %d days, cutoff: %s)" days cutoff-str))
      (print! (item "Current HEAD: %s (%s)" (substring current-rev 0 12) current-date))

      ;; Fetch latest
      (print! (item "Fetching from origin..."))
      (unless (zerop (car (sh! "git" "fetch" "origin" "--tags")))
        (user-error "Failed to fetch from origin"))

      ;; Find target commit: most recent on origin/branch before cutoff
      (let* ((origin-ref (format "origin/%s" upstream-branch))
             (target-rev (cdr (sh! "git" "rev-list" "-1"
                                   (format "--before=%s" cutoff-str)
                                   origin-ref))))
        (unless (and target-rev (not (string-empty-p target-rev)))
          (print! (success "No commits found older than %d days. Nothing to do." days))
          (throw 'safe-upgrade-done nil))

        (let ((target-date (cdr (sh! "git" "log" "-1" "--format=%ai" target-rev)))
              (target-msg  (cdr (sh! "git" "log" "-1" "--format=%s" target-rev)))
              (latest-rev  (cdr (sh! "git" "rev-parse" origin-ref)))
              (skipped     (cdr (sh! "git" "rev-list" "--count"
                                     (format "%s..%s" target-rev origin-ref)))))
          (print! (item "Target:  %s (%s)" (substring target-rev 0 12) target-date))
          (print! (item "         %s" target-msg))
          (print! (item "Latest:  %s" (substring latest-rev 0 12)))
          (print! (item "Skipping %s newer commit(s) still in buffer" skipped))

          (when (equal current-rev target-rev)
            (print! (success "Already at target commit. Nothing to do."))
            (throw 'safe-upgrade-done nil))

          ;; Check if current is already ahead of target
          (when (zerop (car (sh! "git" "merge-base" "--is-ancestor" target-rev current-rev)))
            (print! (success "Current HEAD is already past target. Nothing to do."))
            (throw 'safe-upgrade-done nil))

          (if dry-run?
              (progn
                (print! (warn "[DRY RUN] Would checkout %s" (substring target-rev 0 12)))
                (print! (item "Commits that would be applied:"))
                (print! "%s" (cdr (sh! "git" "--no-pager" "log" "--oneline"
                                       (format "%s..%s" current-rev target-rev)))))
            ;; Check for dirty working tree
            (when-let* ((dirty (doom-upgrade--working-tree-dirty-p default-directory)))
              (user-error "Working tree is dirty. Stash or discard changes first:\n %s"
                          (string-join dirty "\n")))

            (print! (start "Checking out %s..." (substring target-rev 0 12)))
            (unless (zerop (car (sh! "git" "checkout" target-rev)))
              (user-error "Failed to checkout %s" target-rev))
            (print! (success "Doom core updated to %s" (substring target-rev 0 12)))

            ;; Show what was applied
            (print! (item "Applied commits:"))
            (print! "%s" (cdr (sh! "git" "--no-pager" "log" "--oneline"
                                   (format "%s..%s" current-rev target-rev))))

            ;; Sync packages (like doom upgrade does)
            (unless no-sync?
              (print! (start "Running doom sync -u..."))
              (call! (append '("sync" "-u")
                             (if aot? '("--aot"))
                             (if nobuild? '("-B"))
                             (if jobs `("-j" ,jobs)))))
            (print! (success "Finished safe upgrade of Doom Emacs"))))))))

