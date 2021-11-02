;;; org.el -*- lexical-binding: t; -*-

(unless (personal-config-has-profile 'work)
  (map! :leader "X" nil ;; unmap org-capture because I use roam
        (:prefix ("X" . "quick open")
         :desc "open refile" "r" (lambda () (interactive) (find-file "~/Dropbox/todo.org"))
         :desc "open habits" "h"
         (lambda () (interactive)
           (org-roam-node-visit (org-roam-node-from-title-or-alias (format-time-string "%Y-%m-habits")))))))

(use-package! org
  :defer t
  :after personalization
  :init
  (if (personal-config-has-profile 'work)
      (setq org-directory "~/org-roam")
    (setq org-directory "~/Dropbox/org-roam"))
  :config
  (setq-local refile (if (personal-config-has-profile 'work) "~/org-roam/refile.org" ""))
  (setq! org-log-done 'time
         org-agenda-start-with-log-mode t
         org-agenda-files (directory-files-recursively org-directory "\\.org$")
         org-capture-templates
         '(("t" "todo" entry (file+headline refile "Todo") "* TODO %?" :unnarrowed t)
           ("n" "notes" (file+headline refile "Notes") "* %?" :unnarrowed t)))
  (map! :map org-mode-map :leader :nv "m l o" #'org-open-at-point)
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
       ("KILL" . +org-todo-cancel)))))
