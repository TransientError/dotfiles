;;; org-roam.el -*- lexical-binding: t; -*-
(map! :leader :prefix ("r" . "roam")
      "f" #'org-roam-node-find
      "t" #'org-roam-tag-add
      "s" #'org-roam-ref-add
      "l" #'org-roam-node-insert
      "x" #'org-roam-capture)

(use-package! org-roam
  :defer t
  :init
  (setq! org-roam-v2-ack t)
  :config
  (setq! org-roam-directory (file-truename "~/Dropbox/org-roam")
         org-roam-capture-templates
         '(("d" "default" plain "%[/home/kvwu/Dropbox/templates/general.org]"
            :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: \n")
            :unnarrowed t)
           ("r" "Restaurant templates")
           ("rf" "restaurants-file" plain ""
            :target (file+head "restaurants/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: :restaurant:\n")
            :unnarrowed t)
           ("re" "restaurants-entry" plain "%[/home/kvwu/Dropbox/templates/restaurants.org]" :target (file+datetree "" 'day))
           ("c" "cinema-therapy" plain "%[/home/kvwu/Dropbox/templates/cinema-therapy.org]" :target (file+head "%<%Y-%m-%d>-ct-${slug}.org" "#+title: ${title}\n'") :unnarrowed t)
           ("t" "todo" entry "* TODO %?" :target (file+olp "%<%Y-%m-%d>.org" ("Todo")) :unnarrowed t)
           ("T" "therapy")
           ("Tt" "to discuss" plain "**** to dicuss\n" :target (file+datetree "~/Dropbox/org-roam/20211014221049-therapy_log.org" 'day))
           ("Tc" "conclusions" plain "**** conclusions\n" :target (file+datetree "~/Dropbox/org-roam/20211014221049-therapy_log.org" 'day))
           ("D" "doctor")
           ("Dt" "to dicuss" plain "**** to discuss\n" :target (file+datetree "~/Dropbox/org-roam/20211026035038-doctor_log.org" 'day))
           ("Dc" "conclusions" plain "**** conclusions\n" :target (file+datetree "~/Dropbox/org-roam/20211026035038-doctor_log.org" 'day)))
         org-roam-dailies-capture-templates
         '(("d" "default" plain "%[/home/kvwu/Dropbox/templates/journal.org]"
            :target (file+head "%<%Y-%m-%d>.org" "#+title: ${title}\n#+filetags: \n"))))
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
