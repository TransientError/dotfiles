;;; org-roam.el -*- lexical-binding: t; -*-
(map! :leader :prefix ("r" . "roam")
      "f" #'org-roam-node-find
      "t" #'org-roam-tag-add
      "s" #'org-roam-ref-add
      "l" #'org-roam-node-insert
      "x" #'org-roam-capture
      (:prefix ("d" . "dailies")
       (:prefix ("g" . "go")
        "t" #'org-roam-dailies-goto-today
        "y" #'org-roam-dailies-goto-yesterday
        "d" #'org-roam-dailies-goto-date
        "n" #'org-roam-dailies-goto-next-note)
       (:prefix ("c" . "capture")
        "t" #'org-roam-dailies-capture-today
        "y" #'org-roam-dailies-capture-yesterday
        "d" #'org-roam-dailies-capture-date)))

(use-package! org-roam
  :defer t
  :after org
  :init
  (setq! org-roam-v2-ack t)
  :config
  (setq! org-roam-directory (file-truename org-directory)
         org-roam-capture-templates
         '(("d" "default" plain "%[/home/kvwu/Dropbox/templates/general.org]"
            :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: \n")
            :unnarrowed t)
           ("r" "restaurants" plain "%[/home/kvwu/Dropbox/templates/restaurants.org]"
            :target (file+head "restaurants/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: :restaurant:\n")
            :unnarrowed t
            :empty-lines-after 1)
           ("c" "cinema-therapy" plain "%[/home/kvwu/Dropbox/templates/cinema-therapy.org]"
            :target (file+head "%<%Y-%m-%d>-ct-${slug}.org" "#+title: ${title}\n'")
            :unnarrowed t)
           ("t" "todo" entry "* TODO %?" :target (file+olp "%<%Y-%m-%d>.org" ("Todo")) :unnarrowed t)
           ("m" "meetings" plain "%[~/Dropbox/templates/meetings.org]"
            :target (file+head "%<%Y-%m-%d>-ct-${slug}.org" "#+title: ${title}\n'")
            :unnarrowed t
            :empty-lines-after 1))
         org-roam-dailies-capture-templates
         '(("d" "default" plain "%[/home/kvwu/Dropbox/templates/journal.org]"
            :target (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n"))))
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
