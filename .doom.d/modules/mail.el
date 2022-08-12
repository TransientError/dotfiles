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
                        (smtpmail-smtp-user . "kgqw503")
                        (smtpmail-smtp-server . "smtp.gmail.com")
                        (smtpmail-smtp-service . 587))
                      t)
  (set-email-account! "protonmail"
                      '((mu4e-sent-folder . "/protonmail/Sent")
                        (mu4e-drafts-folder . "/protonmail/Drafts")
                        (mu4e-trash-folder . "/protonmail/Trash")
                        (mu4e-refile-folder . "/protonmail/Archive")
                        (smtpmail-smtp-user . "kev.wu")
                        (smtpmail-smtp-server . "127.0.0.1")
                        (smtpmail-stream-type . plain)
                        (user-mail-address . "kev.wu@protonmail.com")
                        (smtpmail-smtp-service . 1025))
                      nil)

  (setq! mu4e-view-html-plaintext-ratio-heuristic most-positive-fixnum
         mu4e-view-prefer-html nil
         mail-user-agent #'mu4e-user-agent
         mu4e-compose-context-policy 'ask-if-none
         smtpmail-servers-requiring-authorization "127.0.0.1"
         mu4e-get-mail-command "true"
         mu4e-update-interval (* 15 60)) ; 15 minutes

  (cond (IS-MAC (setq! message-send-mail-function 'sendmail-send-it sendmail-program (executable-find "msmtp")))
        (IS-LINUX (setq! message-send-mail-function 'smtpmail-send-it
                         smtpmail-local-domain "gmail.com"
                         smtpmail-default-smtp-server "smtp.gmail.com"
                         browse-url-browser-function #'browse-url-chrome)))

  (add-to-list 'mm-discouraged-alternatives "text/html")
  (setq mu4e-bookmarks
        '((:name "Inbox"
           :query "maildir:/gmail/Inbox and not flag:trashed"
           :key ?i)
          (:name "Protonmail Inbox"
           :query "maildir:/protonmail/Inbox and not flag:trashed"
           :key ?p)
          (:name "Unread messages"
           :query "flag:unread and not flag:trashed and not flag:seen and maildir:/gmail/Inbox"
           :key ?u))))

(use-package! org-msg
  :init
  (setq! +org-msg-accent-color "#000000"))
