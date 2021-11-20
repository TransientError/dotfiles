;;; mail.el -*- lexical-binding: t; -*-

(let ((distroString (kvwu/which-linux-distribution)))
  (when (and distroString (string-equal "Ubuntu" (car (split-string distroString))))
    (add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e")))

(use-package! mu4e
  :defer-incrementally t
  :config
  (set-email-account! "gmail"
                      '((mu4e-sent-folder . "/gmail/[Gmail]/Sent Mail")
                        (mu4e-drafts-folder . "/gmail/[Gmail]/Drafts")
                        (mu4e-trash-folder . "/gmail/[Gmail]/Trash")
                        (mu4e-refile-folder . "/gmail/[Gmail]/All Mail")
                        (smtpmail-smtp-user . "kgqw503"))
                      t)
  (setq! mu4e-view-html-plaintext-ratio-heuristic most-positive-fixnum
         mu4e-view-prefer-html nil
         mail-user-agent #'mu4e-user-agent)

  (cond (IS-MAC (setq! message-send-mail-function 'sendmail-send-it sendmail-program (executable-find "msmtp")))
        (IS-LINUX (setq! message-send-mail-function 'smtpmail-send-it
                         smtpmail-local-domain "gmail.com"
                         smtpmail-default-smtp-server "smtp.gmail.com"
                         smtpmail-smtp-server "smtp.gmail.com"
                         smtpmail-smtp-service 587
                         browse-url-browser-function #'browse-url-chrome)))

  (add-to-list 'mm-discouraged-alternatives "text/html")
  (setq mu4e-bookmarks
        '((:name "Inbox"
           :query "maildir:/gmail/Inbox and not flag:trashed"
           :key ?i)
          (:name "Unread messages"
           :query "flag:unread and not flag:trashed and not flag:seen and maildir:/gmail/Inbox"
           :key ?u))))

(use-package! org-msg
  :defer t
  :init
  (setq! +org-msg-accent-color "#000000"))
