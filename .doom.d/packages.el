;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or
;; use 'M-x doom/reload'.


;; To install SOME-PACKAGE from MELPA, ELPA or emacsmirror:
                                        ;(package! some-package)

;; To install a package directly from a remote git repo, you must specify a
;; `:recipe'. You'll find documentation on what `:recipe' accepts here:
;; https://github.com/raxod502/straight.el#the-recipe-format
                                        ;(package! another-package
                                        ;  :recipe (:host github :repo "username/repo"))

;; If the package you are trying to install does not contain a PACKAGENAME.el
;; file, or is located in a subdirectory of the repo, you'll need to specify
;; `:files' in the `:recipe':
                                        ;(package! this-package
                                        ;  :recipe (:host github :repo "username/repo"
                                        ;           :files ("some-file.el" "src/lisp/*.el")))

;; If you'd like to disable a package included with Doom, you can do so here
;; with the `:disable' property:
                                        ;(package! builtin-package :disable t)

;; You can override the recipe of a built in package without having to specify
;; all the properties for `:recipe'. These will inherit the rest of its recipe
;; from Doom or MELPA/ELPA/Emacsmirror:
                                        ;(package! builtin-package :recipe (:nonrecursive t))
                                        ;(package! builtin-package-2 :recipe (:repo "myfork/package"))

;; Specify a `:branch' to install a package from a particular branch or tag.
;; This is required for some packages whose default branch isn't 'master' (which
;; our package manager can't deal with; see raxod502/straight.el#279)
                                        ;(package! builtin-package :recipe (:branch "develop"))

;; Use `:pin' to specify a particular commit to install.
                                        ;(package! builtin-package :pin "1a2b3c4d5e")


;; Doom's packages are pinned to a specific commit and updated from release to
;; release. The `unpin!' macro allows you to unpin single packages...
                                        ;(unpin! pinned-package)
;; ...or multiple packages
                                        ;(unpin! pinned-package another-pinned-package)
;; ...Or *all* packages (NOT RECOMMENDED; will likely break things)
                                        ;(unpin! t)



(package! company-tabnine)
(package! org-tree-slide)
(package! vimrc-mode)
(package! ob-mermaid)
(package! mermaid-mode)
(when (personal-config-has-profile 'roam)
  (package! websocket)
  (package! org-roam-ui :recipe (:host github :repo "org-roam/org-roam-ui" :files ("*.el" "out"))))
(package! powershell)
(package! ahk-mode)
(when (executable-find "journalctl") (package! journalctl-mode))
(package! fasd)
(package! super-save)
(when IS-MAC (package! exec-path-from-shell))
(package! wordel)
(package! ztree)
(when (personal-config-has-profile 'ledger)
  (package! hledger-mode)
  (package! flycheck-hledger)
  (package! ledger-mode))
(package! copilot :recipe (:host github :repo "copilot-emacs/copilot.el" :files ("*.el" "dist")))
(when (personal-config-has-profile 'work)
  (package! kusto-mode :recipe (:host github :repo "ration/kusto-mode.el" :files ("*.el"))))
(package! org-protocol-capture-html)
(package! evil-fringe-mark)
(unpin! evil-collection)
(package! evil-collection
  :recipe (:repo "emacs-evil/evil-collection" :branch "master"))
(package! org-super-agenda)
(package! org-habit-stats)
(package! i3wm-config-mode)
(package! kbd-mode
  :recipe (:host github
           :repo "kmonad/kbd-mode"))
(package! graphql-mode)
(package! copilot-chat)
(package! evil-easymotion :disable t)

(when (file-exists-p (concat doom-private-dir "packages-secrets.el")) (load! "packages-secrets.el"))

;; No longer used but kept here for reference
;; (package! protobuf-mode)
;; (package! sql)
;; (when (executable-find "python")
;;   (package! poetry
;;     :recipe (:host github :repo "TransientError/poetry"))
;;   (unpin! poetry))
