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
(let ((text-scale (cond ((string-equal system-type "windows-nt") 1)
                        (t 1))))
  (setq doom-font (font-spec :family "Liga Hack" :size (* 14 text-scale))
        doom-variable-pitch-font (font-spec :family "Liga Hack" :size (* 13 text-scale) :weight 'bold)))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:

(defun kvwu/choose-theme ()
  (cond ((not (display-graphic-p)) (load-theme 'doom-opera t)) (t (load-theme 'doom-material t))))
(kvwu/choose-theme)
(add-hook 'server-after-make-frame-hook #'kvwu/choose-theme)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; Autosave!
(setq super-save-auto-save-when-idle t)
(super-save-mode +1)
(add-hook 'doom-before-reload-hook
          (defun kvwu/save-before-reload ()
            (when (and buffer-file-name (string-match-p ".doom.d" buffer-file-name)) (save-buffer))))


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

;; global
(map! :vni "C-v" #'yank)
(setq-default fill-column 120)
(after! text-mode (when (executable-find "aspell") (setq! ispell-dictionary "en")))
(add-to-list 'prog-mode-hook #'display-fill-column-indicator-mode)
(remove-hook 'write-file-functions #'whitespace-write-file-hook)
(when (executable-find "aw-qt") (global-activity-watch-mode))
(setq! enable-local-variables t
       native-comp-deferred-compilation t
       use-package-always-defer t)

;; macos
(when IS-MAC (exec-path-from-shell-initialize) (map! :leader :n "o f" #'toggle-frame-maximized))

;; ws-butler
(after! ws-butler (setq! ws-butler-keep-whitespace-before-point t))

;; browse-url
(when (and (featurep! :kvwu work) (kvwu/is-wsl))
  (setq browse-url-browser-function 'browse-url-generic
        browse-url-generic-program "/mnt/c/Program Files/Google/Chrome/Application/chrome.exe"))

;; evil
(after! evil (map! :map evil-normal-state-map "U" #'evil-redo :leader "w v" #'evil-window-vnew "w s" #'evil-window-new))
(after! evil-multiedit (map! :map evil-multiedit-mode-map :vn "R" #'evil-multiedit-match-all))

(load! "modules/org.el")

;; tabnine
(use-package! company-tabnine
  :after company
  :config
  (add-to-list 'company-backends 'company-tabnine)
  (setq +lsp-company-backend '(company-lsp :with company-tabnine :separate)))

;; magit
(after! magit (setq magit-save-repository-buffers 'dontask))
(after! magit-blame
  (setq magit-blame-styles '((margin
                              (margin-format    . (" %s%f" " %C %a" " %H"))
                              (margin-width     . 42)
                              (margin-face      . magit-blame-margin)
                              (margin-body-face . (magit-blame-dimmed))))))

;; journalctl
(when (executable-find "journalctl")
  (after! journalctl (map! :nv "]]" #'journalctl-next-chunk "[[" #'journalctl-previous-chunk)))

;; ledger
(when (featurep! :kvwu ledger)
  (after! evil (evil-set-initial-state 'ledger-reconcile-mode 'motion))
  (map! :leader :desc "ledger" "X l" (cmd! () (find-file "~/Dropbox/ledgers/ledger.ledger"))
        (:after ledger-mode :map ledger-mode-map
         :localleader "f" #'ledger-mode-clean-buffer
         :localleader "y" #'ledger-copy-transaction-at-point
         :localleader "o" #'ledger-occur)))


;; fasd
(when (executable-find "fasd")
  (map! :leader "f f" #'fasd-find-file)
  (use-package! fasd :after ivy :demand (global-fasd-mode)))

;; elisp
(setq-hook! 'emacs-lisp-mode-hook tab-width 2 evil-shift-width 2)

;; find file
(after! ivy
  (defun kvwu/find-file (prefix query)
    (interactive "P\nMquery:")
    (let* ((results (split-string (shell-command-to-string (concat "fd " (if prefix "-HI " "") query)))))
      (if results (ivy-read "" results :action #'find-file) (message "No results!"))))
  (map! :desc "search for file" :leader "s f" #'kvwu/find-file))

;; calendar
(when (featurep! :kvwu calendar)
  (setq kvwu/calendar-file "~/org/calendar.org")
  (defun kvwu/calendar ()
    (interactive)
    (cfw:open-calendar-buffer
     :contents-sources
     (list (cfw:org-create-file-source "cal" kvwu/calendar-file "Blue"))))

  (use-package! org-gcal
    :config
    (let* ((email "kgqw503@gmail.com") (plist (kvwu/rbw-get-full-secret-plist "accounts.google.com" email)))
      (setq! org-gcal-client-id (plist-get plist 'calendar-client-id)
             org-gcal-client-secret (plist-get plist 'calendar-client-secret)
             org-gcal-fetch-file-alist `((,email . ,kvwu/calendar-file))
             org-gcal-auto-archive nil))))

;; wordel
(after! (wordel evil)
  (evil-make-intercept-map wordel-mode-map)
  (evil-make-intercept-map wordel-select-mode-map)
  (evil-set-initial-state  'wordel-mode 'insert)
  (evil-set-initial-state  'wordel-select-mode 'insert))



(load! "modules/python.el")
(load! "modules/javascript.el")
(load! "modules/rust.el")
(when (featurep! :kvwu mail) (load! "modules/mail.el"))
(when (featurep! :kvwu roam) (load! "modules/org-roam.el"))
