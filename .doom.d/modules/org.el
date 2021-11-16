;;; org.el -*- lexical-binding: t; -*-

(defun ndk/org-set-effort-in-pomodoros (&optional n)
  "This `fn` facilitate to define efforts in tasks in pomodoros units.
You can use interactively by typing `C-c C-x e` or by sending parameter as `M-3 C-c C-x e`."
  (interactive "P")
  (setq n (or n (string-to-number (read-from-minibuffer "How many pomodoros? " nil nil nil nil "1" nil))))
  (let* ((mins-per-pomodoro 25))
    (org-set-effort nil (org-duration-from-minutes (* n mins-per-pomodoro)))))

(map! :leader "X" nil ;; unmap org-capture because I use roam
      (:prefix ("X" . "quick open")
       :desc "open refile" "r"
       (lambda () (interactive)
         (find-file (if (personal-config-has-profile 'work) "~/org-roam/refile.org" "~/Dropbox/todo.org")))
       (:unless (personal-config-has-profile 'work)
        :desc "open habits" "h"
        (lambda () (interactive)
          (org-roam-node-visit (org-roam-node-from-title-or-alias (format-time-string "%Y-%m-habits")))))
       (:when (personal-config-has-profile 'work)
        :desc "open todo" "t" (lambda () (interactive) (find-file "~/org-roam/todo.org"))
        :desc "open personal" "p" (lambda () (interactive) (find-file "~/org-roam/personal.org")))))

(use-package! org
  :defer t
  :after personalization
  :init
  (setq org-directory
    (cond ((and (personal-config-has-profile 'work) (personal-config-has-profile 'roam)) "~/org-roam")
          ((personal-config-has-profile 'roam) "~/Dropbox/org-roam")
          (t "~/org")))
  :config
  (setq-local refile (if (personal-config-has-profile 'work) "~/org-roam/refile.org" ""))
  (setq! org-log-done 'time
         org-capture-templates
         '(("t" "todo" entry (file+headline refile "Todo") "* TODO %?" :unnarrowed t)
           ("n" "notes" (file+headline refile "Notes") "* %?" :unnarrowed t)))
  (when (personal-config-has-profile 'work)
    (setq!
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
        "KILL(k)" ; Task was cancelled, aborted or is no longer applicable
        "HAND-OFF(a)"
        "PUNT(u)"))
     org-todo-keyword-faces
     '(("IN_PROGRESS" . +org-todo-active)
       ("BLOCKED" . +org-todo-onhold)
       ("HOLD" . +org-todo-onhold)
       ("REVIEW" . +org-todo-onhold)
       ("PROJ" . +org-todo-project)
       ("NO"   . +org-todo-cancel)
       ("KILL" . +org-todo-cancel))))
  (map! :map org-mode-map :localleader :desc "estimate pomodoros" "c E" #'ndk/org-set-effort-in-pomodoros))

(use-package! org-agenda
  :after org
  :defer t
  :config
  (setq! org-agenda-start-with-log-mode t
         org-agenda-files (directory-files-recursively org-directory "\\.org$"))
  (when (personal-config-has-profile 'work)
    (setq! org-agenda-custom-commands
           '(("n" "Agenda and all TODOS" ((agenda "") (alltodo "")))
             ("w" "Serious agenda" ((agenda "work") (tags-todo "work")))))))
