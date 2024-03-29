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
       :desc "open todo" "t" (cmd! () (find-file (concat org-directory "todo.org")))
       (:unless (personal-config-has-profile 'work)
        :desc "open habits" "h"
        (cmd! () (org-roam-node-visit (org-roam-node-from-title-or-alias (format-time-string "%Y-%m-habits"))))
        :desc "open journal" "j" (cmd! () (find-file (concat org-directory "journal.org"))))
       (:when (personal-config-has-profile 'work)
        :desc "open personal" "p" (cmd! () (find-file "~/org-roam/personal.org")))))

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
                                                "BLOCKED(b)"  ; Something external is holding up this task
                                                "HOLD(h)"  ; This task is paused/on hold because of me
                                                "IDEA(i)"  ; An unconfirmed and unapproved task or notion
                                                "|"
                                                "DONE(d)"  ; Task successfully completed
                                                "CANCELLED(c)" ; Task was cancelled, aborted or is no longer applicable
                                                "HAND-OFF(a)"
                                                "PUNT(u)"))
                                             org-todo-keyword-faces
                                             '(("IN_PROGRESS" . +org-todo-active)
                                               ("BLOCKED" . +org-todo-onhold)
                                               ("HOLD" . +org-todo-onhold)
                                               ("REVIEW" . +org-todo-onhold)
                                               ("PROJ" . +org-todo-project)
                                               ("NO"   . +org-todo-cancel)
                                               ("CANCEL" . +org-todo-cancel))))
  (map! :map org-mode-map :localleader :desc "estimate pomodoros" "c E" #'ndk/org-set-effort-in-pomodoros)
  (require 'org-protocol-capture-html))
  

(use-package! org-agenda
  :after org
  :config
  (setq! org-agenda-start-with-log-mode t org-agenda-files (directory-files-recursively org-directory "\\.org$"))
  (when (personal-config-has-profile 'work) (setq! org-agenda-custom-commands
                                                   '(("n" "Agenda and all TODOS" ((agenda "") (alltodo "")))
                                                     ("w" "Serious agenda" ((agenda "work") (tags-todo "work")))))))
