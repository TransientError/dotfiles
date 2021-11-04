;;; org-roam.el -*- lexical-binding: t; -*-

(map! :leader :prefix "nr"
      "t" #'org-roam-tag-add
      "S" #'org-roam-ref-add)

(use-package! org-roam
  :defer t
  :after org
  :config
  (if (personal-config-has-profile 'work)
      (setq! org-roam-capture-templates
             '(("d" "default" plain ""
                :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: \n") :unnarrowed t)
               ("m" "meetings" plain ""
                :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"  "#+title: ${title}\n#+filetags: \n") :unnarrowed t)))
    (setq! org-roam-capture-templates
           '(("d" "default" plain  "%[/home/kvwu/Dropbox/templates/general.org]"
              :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: \n")
              :unnarrowed t)
             ("r" "restaurants" plain "%[/home/kvwu/Dropbox/templates/restaurants.org]"
              :target (file+head
                       "restaurants/%<%Y%m%d%H%M%S>-${slug}.org"
                       "#+title: ${title}\n#+filetags: :restaurant:\n")
              :unnarrowed t
              :empty-lines 1)
             ("c" "cinema-therapy" plain "%[/home/kvwu/Dropbox/templates/cinema-therapy.org]"
              :target (file+head "%<%Y-%m-%d>-ct-${slug}.org" "#+title: ${title}\n'")
              :unnarrowed t)
             ("t" "todo" entry "* TODO %?" :target (file+olp "%<%Y-%m-%d>.org" ("Todo")) :unnarrowed t)
             ("m" "meetings" plain "%[~/Dropbox/templates/meetings.org]"
              :target (file+head "%<%Y-%m-%d>-ct-${slug}.org" "#+title: ${title}\n'")
              :unnarrowed t
              :empty-lines 1))))

  (setq! org-roam-directory (file-truename org-directory)
         org-roam-dailies-capture-templates
         '(("d" "default" plain "%[/home/kvwu/Dropbox/templates/journal.org]"
            :target (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n"))
           ("t" "todo" entry "* TODO " :target (file+olp "%<%Y-%m-%d>.org" ("Todo")) :unnarrowed t)
           ("n" "notes" entry "* %?" :target (file+olp "%<%Y-%m-%d>.org" ("Notes")) :unnarrowed t)))
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
