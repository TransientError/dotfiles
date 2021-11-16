;;; org-roam.el -*- lexical-binding: t; -*-

(map! :leader :prefix "nr"
      "t" #'org-roam-tag-add
      "S" #'org-roam-ref-add)

(use-package! org-roam
  :defer t
  :after org
  :init
  (setq org-roam-directory (file-truename org-directory))
  :config
  (let ((filename-template "%<%Y%m%d%H%M%S>-${slug}.org")
        (default-headers "#+title: ${title}\n#+filetags: \n")
        (headers-with-tag (lambda (tags) (format "#+title: ${title}\n#+filetags: %s\n" tags)))
        (mk-template-path (lambda (file-name) (concat (getenv "HOME") "/Dropbox/templates/" file-name)))
        (roam-daily-filename-template "%<%Y-%m-%d>.org"))
    (if (personal-config-has-profile 'work)
        (setq! org-roam-capture-templates
               `(("d" "default" plain ""
                  :target (file+head ,filename-template ,default-headers) :unnarrowed t)
                 ("m" "meetings" plain ""
                  :target (file+head ,filename-template ,default-headers) :unnarrowed t)))
      (setq! org-roam-capture-templates
             `(("d" "default" plain  (file ,(funcall mk-template-path "general.org"))
                :target (file+head ,filename-template ,default-headers)
                :unnarrowed t)
               ("r" "restaurants" plain (file ,(funcall mk-template-path "restaurants.org"))
                :target (file+head
                         ,(concat "restaurants/" filename-template)
                         ,(funcall headers-with-tag ":restaurant:"))
                :unnarrowed t
                :empty-lines 1)
               ("c" "cinema-therapy" plain (file ,(funcall mk-template-path "cinema-therapy.org"))
                :target (file+head "%<%Y-%m-%d>-ct-${slug}.org" ,default-headers)
                :unnarrowed t)
               ("t" "todo" entry "* TODO %?" :target (file+olp ,roam-daily-filename-template ("Todo")) :unnarrowed t)
               ("m" "meetings" plain (file ,(funcall mk-template-path "meetings.org"))
                :target (file+head "%<%Y-%m-%d>-${slug}.org" ,default-headers)
                :unnarrowed t
                :empty-lines 1))
             org-roam-dailies-capture-templates
             `(("d" "default" plain (file ,(funcall mk-template-path "journal.org"))
                :target (file+head ,roam-daily-filename-template "#+title: %<%Y-%m-%d>\n"))
               ("t" "todo" entry "* TODO " :target (file+olp ,roam-daily-filename-template ("Todo")) :unnarrowed t)
               ("n" "notes" entry "* %?" :target (file+olp ,roam-daily-filename-template ("Notes")) :unnarrowed t)))))
  (org-roam-db-autosync-mode))

(use-package! websocket
  :defer t
  :after org-roam)
(use-package! org-roam-ui
  :defer t
  :after org-roam
  (setq! org-roam-ui-sync-theme t
         org-roam-ui-follow t
         org-roam-ui-update-on-save t
         org-roam-ui-open-on-start t))
