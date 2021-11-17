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

(defun kvwu/choose-theme ()
  (cond ((not (display-graphic-p)) (load-theme 'doom-opera t)) (t (load-theme 'doom-material t))))
(add-hook 'server-after-make-frame-hook #'kvwu/choose-theme)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; Autosave!
(setq super-save-auto-save-when-idle t)
(super-save-mode +1)

(remove-hook 'write-file-functions #'whitespace-write-file-hook)

(when (executable-find "aw-qt") (global-activity-watch-mode))

(setq enable-local-variables t)

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

(map! :vni "C-v" #'yank)
(setq-default fill-column 120)

(after! evil (map! :vn "U" #'evil-redo))

(when IS-MAC (exec-path-from-shell-initialize))

(setq! native-comp-deferred-compilation t)

(use-package! evil-multiedit :config (map! :vn "R" #'evil-multiedit-match-all))

(after! text-mode (when (executable-find "aspell") (setq! ispell-dictionary "en")))

(add-to-list 'prog-mode-hook #'display-fill-column-indicator-mode)

(after! ws-butler (setq! ws-butler-keep-whitespace-before-point t))

(when (and (personal-config-has-profile 'work) (kvwu/is-wsl))
  (setq browse-url-browser-function 'browse-url-generic
    browse-url-generic-program "/mnt/c/Program Files/Google/Chrome/Application/chrome.exe"))

(load! "modules/org.el")

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

;; journalctl
(when (executable-find "journalctl")
  (use-package! journalctl
    :defer t
    :config
    (map! :nv
      "]]" #'journalctl-next-chunk
      "[[" #'journalctl-previous-chunk)))

;; ledger
(when (personal-config-has-profile 'ledger)
  (map! :leader :desc "ledger" "X l" (lambda () (interactive) (find-file "~/Dropbox/ledgers/ledger.ledger"))
    (:after ledger-mode :map ledger-mode-map :localleader "f" #'ledger-mode-clean-buffer)))

;; fasd
(when (executable-find "fasd")
  (global-fasd-mode)
  (map! :leader "f f" #'fasd-find-file))

;; elisp
(use-package! elisp-mode
  :defer t
  :init
  (setq lisp-indent-offset 2))

(load! "modules/python.el")
(load! "modules/javascript.el")
(load! "modules/rust.el")
(when (personal-config-has-profile 'mail) (load! "modules/mail.el"))
(when (personal-config-has-profile 'roam) (load! "modules/org-roam.el"))
