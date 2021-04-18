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
(remove-hook 'write-file-functions #'whitespace-write-file-hook)
(global-activity-watch-mode)

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

(load! "config-manager.el")
(load! "misc.el")
(when (file-exists-p "personalization.el")
      (load! "personalization.el"))

(use-package! lsp-rust
  :defer t
  :config
  (setq! lsp-rust-server 'rust-analyzer
         lsp-rust-analyzer-server-display-inlay-hints t
         lsp-rust-clippy-preference "on"))

(add-hook! 'rustic-mode-hook #'rainbow-delimiters-mode)

(use-package! evil-multiedit
  :defer t
  :config
  (map! :map evil-visual-state-map :n "R" #'evil-multiedit-match-all))

;; org
(use-package! org
  :defer t
  :config
  (setq! org-log-done 'time
         org-agenda-start-with-log-mode t)
  (when (personal-config-has-profile 'work) (setq!
         org-todo-keywords
        '((sequence
           "TODO(t)"  ; A task that needs doing & is ready to do
           "PROJ(p)"  ; A project, which usually contains other tasks
           "IN-PROGRESS(s)"  ; A task that is in progress
           "REVIEW(r)"  ; A task that is in progress
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

(after! text-mode
  (when (executable-find "aspell")
    (setq! ispell-dictionary "en")))

(use-package! company-tabnine
  :after company
  :defer t
  :config
  (cl-pushnew 'company-tabnine (default-value 'company-backends))
  (setq! +lsp-company-backend '(company-lsp :with company-tabnine :separate)))

(use-package! magit-blame
  :defer t
  :config
  (setq! magit-blame-styles
    '((margin
       (margin-format    . (" %s%f" " %C %a" " %H"))
       (margin-width     . 42)
       (margin-face      . magit-blame-margin)
       (margin-body-face . (magit-blame-dimmed))))))

(after! prog-mode
  (setq! fill-column 120))

(use-package! visual-fill-column
  :hook text-mode org-mode
  :config
  (setq! fill-column 90)
  (visual-line-mode)
  (visual-fill-column-mode))

(after! ws-butler
  (setq! ws-butler-keep-whitespace-before-point t))

(after! python
  (map! :map python-mode-map :leader :n "m p" #'poetry))

(add-to-list 'auto-mode-alist '("\\.jsx?$" . web-mode))
(after! web-mode
  (map! :map emmet-mode-map :leader :n "m E" #'emmet-expand-line))

(use-package! js2-mode
  :after web-mode
  :config
  (setq! web-mode-content-types-alist '(("jsx" . "\\.js[x]?\\'")))
  (setq! web-mode-markup-indent-offset 2))
