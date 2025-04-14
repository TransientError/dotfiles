;;; org.el -*- lexical-binding: t; -*-

(defun ndk/org-set-effort-in-pomodoros (&optional n)
  "This `fn` facilitate to define efforts in tasks in pomodoros units.
You can use interactively by typing `C-c C-x e` or by sending parameter as `M-3 C-c C-x e`."
  (interactive "P")
  (let* ((n (or n (string-to-number (read-from-minibuffer "How many pomodoros? " nil nil nil nil "1" nil))))
         (mins-per-pomodoro 25))
    (org-set-effort nil (org-duration-from-minutes (* n mins-per-pomodoro)))))

(setq org-directory
      (cond
       ((and (personal-config-has-profile 'work) (personal-config-has-profile 'roam) (kvwu/is-wsl))
        "/mnt/c/Users/wukevin/OneDrive - Microsoft/org-roam/")
       ((and
         (personal-config-has-profile 'work)
         (personal-config-has-profile 'roam)
         (string-equal "windows-nt" system-type))
        "~/OneDrive - Microsoft/org-roam/")
       ((personal-config-has-profile 'roam) "~/Dropbox/org-roam/")
       (t "~/Documents/org/")))

(map! :leader "X" nil ;; unmap org-capture because I use roam
      (:prefix ("X" . "quick open")
       :desc "open refile" "r"
       (cmd! () (find-file (if (personal-config-has-profile 'work) "~/org-roam/refile.org" "~/Dropbox/todo.org")))
       :desc "open todo" "t" (cmd! () (if (personal-config-has-profile 'work) (find-file (concat org-directory "todo.org")) (find-file (concat "~/Dropbox/" "todo.org")))
                              (:unless (personal-config-has-profile 'work)
                                :desc "open habits" "h"
                                (cmd! () (find-file "~/Dropbox/habit-tracker.org"))
                                :desc "open journal" "j" (cmd! () (find-file (concat org-directory "journal.org"))))
                              (:when (personal-config-has-profile 'work)
                                :desc "open personal" "p" (cmd! () (find-file "~/org-roam/personal.org")))
                              (:unless (personal-config-has-profile 'work)
                                :desc "open long term" "s" (cmd! () (find-file "~/Dropbox/long-term.org"))))))

(map! :map org-capture-mode-map :i :desc "finalize and go" "C-c C-c" (cmd! () (org-capture-finalize t)))

(use-package! org
  :config
  (setq! org-log-done 'time
         org-capture-templates '(("t" "todo" entry (file+headline "todo.org" "Todo") "* TODO %?" :unnarrowed t)
                                 ("j" "journal" entry (file+olp+datetree "journal.org") "* %?" :unnarrowed t)
                                 ("e" "clip entire" entry (file+headline "notes.org" "Articles")
                                  "* %a :website:\n\n%U %?\n\n%:initial")
                                 ("w" "clip" entry
                                  (file+headline "notes.org" "Inbox") "* %a :website:\n\n%U %?\n\n%:initial"))
         org-archive-location (format "%sarchive.org::datetree/" org-directory)
         org-element-use-cache nil) ;; This feature is not really stable yet

  (when (personal-config-has-profile 'work) (setq!
                                             org-todo-keywords
                                             '((sequence
                                                "TODO(t)"  ; A task that needs doing & is ready to do
                                                "PROJ(p)"  ; A project, which usually contains other tasks
                                                "IN-PROGRESS(s)"  ; A task that is in progress
                                                "REVIEW(r)"  ; task is being reviewed
                                                "PENDING(e)"
                                                "BLOCKED(b)"  ; Something external is holding up this task
                                                "HOLD(h)"  ; This task is paused/on hold because of me
                                                "IDEA(i)"  ; An unconfirmed and unapproved task or notion
                                                "HAND-OFF(a)" ; handed off but still need to track
                                                "|"
                                                "DONE(d)"  ; Task successfully completed
                                                "CANCELLED(c)")) ; Task was cancelled, aborted or is no longer applicable
                                             org-todo-keyword-faces
                                             '(("IN_PROGRESS" . +org-todo-active)
                                               ("BLOCKED" . +org-todo-onhold)
                                               ("HOLD" . +org-todo-onhold)
                                               ("REVIEW" . +org-todo-onhold)
                                               ("PENDING" . +org-todo-onhold)
                                               ("HAND-OFF" . +org-todo-onhold)
                                               ("PROJ" . +org-todo-project)
                                               ("NO"   . +org-todo-cancel)
                                               ("CANCEL" . +org-todo-cancel))))
  (map! :map org-mode-map :localleader :desc "estimate pomodoros" "c E" #'ndk/org-set-effort-in-pomodoros)
  (require 'org-protocol-capture-html)
  (add-to-list 'org-modules 'org-habit t))


(use-package! org-agenda
  :after org org-super-agenda
  :config
  ;; https://github.com/alphapapa/org-super-agenda/issues/50
  (setq org-super-agenda-header-map (make-sparse-keymap))
  (setq! org-agenda-start-with-log-mode t org-agenda-files (directory-files-recursively "~/Dropbox" "\\.org$")
         org-super-agenda-groups '((:name "Today" :and (:time-grid t :not (:habit t)) :and (:scheduled today :not (:habit t)))
                                   (:name "Intentional and Urgent" :priority "A")
                                   (:name "Intentional and Not Urgent" :priority "B")
                                   (:name "Not Intentional and Urgent" :priority "C")
                                   (:name "Not Intentional and Not Urgent" :priority "D")
                                   (:name "Habits" :habit t)))

  (when (personal-config-has-profile 'work) (setq! org-agenda-custom-commands
                                                   '(("n" "Agenda and all TODOS" ((agenda "") (alltodo "")))
                                                     ("w" "Serious agenda" ((agenda "work") (tags-todo "work"))))))
  (add-hook 'org-agenda-mode-hook 'org-super-agenda-mode))

(use-package! org-habit
  :after org
  :config
  (setq! org-habit-show-habits t
         org-habit-following-days 1
         org-habit-preceding-days 7
         org-habit-show-all-today t))

(use-package! org-habit-stats
  :after org
  :config
  (pushnew! evil-emacs-state-modes #'org-habit-stats-mode)
  (map! :map org-habit-stats-mode-map
        "j" #'org-habit-stats-view-next-habit
        "k" #'org-habit-stats-view-previous-habit))

