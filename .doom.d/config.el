;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Kevin"
      user-mail-address "kvwu@transienterror.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
 (setq doom-font (font-spec :family "Liga Hack" :size 14)
       doom-variable-pitch-font (font-spec :family "Liga Hack" :size 13 :weight 'bold))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-vibrant)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/journal")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; Autosave!
(setq! auto-save-visited-mode t
       auto-save-visited-interval 1)
(ws-butler-mode -1)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(use-package! lsp-rust
  :defer t
  :config
  (setq! lsp-rust-server 'rust-analyzer
         lsp-rust-analyzer-server-display-inlay-hints t))

(use-package! evil-multiedit
  :defer t
  :config (map! :map evil-visual-state-map :n "R" #'evil-multiedit-match-all))

;; org
(use-package! org
  :defer t
  :config
  (setq! org-log-done 'time
         org-agenda-start-with-log-mode t))

(setf (alist-get 'markdown-mode +spell-excluded-faces-alist)
        '(markdown-code-face
        markdown-url-face
        markdown-link-face
        markdown-markup-face
        markdown-reference-face
        markdown-html-attr-name-face
        markdown-html-attr-value-face
        markdown-html-tag-name-face))
(setq ispell-dictionary "en")

(use-package! company-tabnine
  :after company
  :defer t
  :config
  (cl-pushnew 'company-tabnine (default-value 'company-backends))
  (setq +lsp-company-backend '(company-lsp :with company-tabnine :separate)))
