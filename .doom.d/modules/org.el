;;; org.el -*- lexical-binding: t; -*-
(use-package! org
  :defer t
  :after personalization
  :config
  (setq! org-log-done 'time
         org-agenda-start-with-log-mode t
         org-agenda-files (directory-files-recursively org-directory "\\.org$"))
  (map! :map org-mode-map :leader :nv "m l o" #'org-open-at-point)
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
                                                "KILL(k)"
                                                "HAND-OFF(a)"
                                                "PUNT(u)")) ; Task was cancelled, aborted or is no longer applicable
                                             org-todo-keyword-faces
                                             '(("IN_PROGRESS" . +org-todo-active)
                                               ("BLOCKED" . +org-todo-onhold)
                                               ("HOLD" . +org-todo-onhold)
                                               ("REVIEW" . +org-todo-onhold)
                                               ("PROJ" . +org-todo-project)
                                               ("NO"   . +org-todo-cancel)
                                               ("KILL" . +org-todo-cancel)))))

