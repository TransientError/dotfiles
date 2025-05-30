;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq use-package-compute-statistics t)
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
  (setq doom-font (font-spec :family "LigaHack Nerd Font" :size (* 14 text-scale))
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
(remove-hook 'doom-first-input-hook #'evil-snipe-mode)
(map! :vni "C-v" #'yank)
(setq-default fill-column 120)
(after! text-mode (when (executable-find "aspell") (setq! ispell-dictionary "en")))
(add-to-list 'prog-mode-hook #'display-fill-column-indicator-mode)
(remove-hook 'write-file-functions #'whitespace-write-file-hook)
(setq! native-comp-deferred-compilation t
       use-package-always-defer t)
(global-evil-fringe-mark-mode)

;; macos
(when IS-MAC (exec-path-from-shell-initialize) (map! :leader :n "o f" #'toggle-frame-maximized))

;; ws-butler
(after! ws-butler (setq! ws-butler-keep-whitespace-before-point t))

;; browse-url
(when (and (personal-config-has-profile 'work) (kvwu/is-wsl))
  (setq browse-url-browser-function 'browse-url-generic browse-url-generic-program (kvwu/wsl-browser 'edge)))

;; evil
(after! evil
  (map!
   :map evil-normal-state-map
   "U" #'evil-redo
   :leader
   "w v" #'evil-window-vnew
   "w s" #'evil-window-new)
  (setq avy-timeout-seconds 0.3)
  (map! :n "s" #'evil-avy-goto-char-2 :n "S" #'evil-avy-goto-char-timer))

(use-package! evil-surround
  :demand t
  :after evil
  :config
  (evil-define-command evil-sandwich (char)
    (interactive (evil-surround-input-char))
    (call-interactively
        (pcase char
            (?a #'evil-surround-region)
            (?r #'evil-surround-change)
            (?d #'evil-surround-delete))))
  (map! :n "g s" 'evil-sandwich))



(after! evil-multiedit (map! :map evil-multiedit-mode-map :vn "R" #'evil-multiedit-match-all))

(load! "modules/org.el")

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

;; fasd
(when (executable-find "fasd")
  (map! :leader "f f" #'fasd-find-file)
  (use-package! fasd :after ivy :demand (global-fasd-mode)))

;; elisp
(after! elisp-mode
  (unsetq-hook! 'emacs-lisp-mode-hook tab-width) ;; set in emacs-lisp doom config after elisp-mode
  (setq-hook! 'emacs-lisp-mode-hook tab-width 2))

;; find file
(after! ivy
  (defun kvwu/find-file (prefix query)
    (interactive "P\nMquery:")
    (let* ((results (split-string (shell-command-to-string (concat "fd " (if prefix "-HI " "") query)))))
      (if results (ivy-read "" results :action #'find-file) (message "No results!"))))
  (map! :desc "search for file" :leader "s f" #'kvwu/find-file))

;; calendar
(when (personal-config-has-profile 'calendar)
  (defun kvwu/calendar ()
    (interactive)
    (cfw:open-calendar-buffer
     :contents-sources
     (list
      (cfw:ical-create-source
       "gcal"
       (kvwu/get-secret "google-calendar-private-url.txt.gpg")
       "Blue")))))

;; wordel
(after! (wordel evil)
  (evil-make-intercept-map wordel-mode-map)
  (evil-make-intercept-map wordel-select-mode-map)
  (evil-set-initial-state  'wordel-mode 'insert)
  (evil-set-initial-state  'wordel-select-mode 'insert))

;; ediff
(after! ediff
  (let ((black (doom-color 'base0)) (red (doom-color 'red)) (green (doom-color 'green)))
    (set-face-attribute 'ediff-fine-diff-A nil :foreground black :background red)
    (set-face-foreground ediff-current-diff-face-A red)
    (set-face-attribute 'ediff-fine-diff-B nil :foreground black :background green)
    (set-face-foreground ediff-current-diff-face-B green)))

;; copilot
(use-package! copilot
  :after company
  :hook (prog-mode . copilot-mode)
  :init
  (setq copilot-indent-offset-warning-disable t)
  :config
  (customize-set-variable 'copilot-enable-predicates '(evil-insert-state-p))
  (map! :desc "copilot" :map company-mode-map :i
        "TAB" (defun kvwu/copilot-tab () (interactive)
                     (or (copilot-accept-completion) (company-indent-or-complete-common nil)))
        "<right>" (defun kvwu/copilot-right () (interactive) (copilot-accept-completion) (evil-insert 1))
        "<C-right>" (copilot-accept-completion-by-word)
        "<C-S-right>" (copilot-accept-completion-by-line)))

(use-package! copilot-chat :after (org))

;; tabnine
(when (personal-config-has-profile 'tabnine)
  (use-package! company-tabnine
    :after company
    :init
    (defun kvwu/activate-tabnine ()
      (interactive)
      (add-to-list 'company-backends 'company-tabnine))
    :config
    (setq +lsp-company-backends '(company-tabnine))
    (map! :desc "tabnine" :map company-mode-map :i "TAB"
          (defun kvwu/tabnine-tab () (interactive) (company-indent-or-complete-common nil)))))

;; json
(add-hook 'json-mode-hook #'rainbow-delimiters-mode)

;; lua
(add-hook 'lua-mode-hook #'rainbow-delimiters-mode)
(after! lua-mode
  (set-formatter! 'stylua (format "stylua -f %s/.config/stylua/stylua.toml -" (getenv "HOME"))  :modes '(lua-mode)))

;; csharp
(when (personal-config-has-profile 'work)
  (setq lsp-csharp-server-path "/usr/sbin/omnisharp"))

;; fish
;; Fish (and possibly other non-POSIX shells) is known to inject garbage
;; output into some of the child processes that Emacs spawns. Many Emacs
;; packages/utilities will choke on this output, causing unpredictable
;; issues
(setq shell-file-name (executable-find "bash"))
;;
;; mermaid
(after! mermaid
  (add-to-list 'auto-mode-alist '("\\.mmdc\\'" . mermaid-mode)))

;; HACK: since some upstream changes, formatting a specific region seems broken, and
;; calling `+format/region' raises: "with Symbol’s function definition is void:
;; apheleia--get-formatters", ensure to autoload the required function.
(use-package! apheleia
  :commands (apheleia--get-formatters))

(use-package! kbd-mode)

(when (personal-config-has-profile 'work)
  (defun kvwu/yank-image-from-win-clipboard-through-powershell()
    (interactive)
    (let* ((powershell "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe"))
      (file-name (format-time-string "screenshot_%Y%m%d_%H%M%S.png"))
      (file-path-wsl (concat "./images/" file-name))

      (shell-command
       (concat
        powershell
        " -command \"(Get-Clipboard -Format Image).Save(\\\"C:/Users/wukevin/OneDrive - Microsoft/Pictures/Screenshots/"
        file-name
        "\\\")\""))
      (rename-file (concat "/mnt/c/Users/wukevin/OneDrive - Microsoft/Pictures/Screenshots/" file-name) file-path-wsl)
      (insert (concat "[[file:" file-path-wsl "]]"))
      (message "insert DONE."))))


(when (modulep! :lang python) (load! "modules/python.el"))
(when (modulep! :lang javascript) (load! "modules/javascript.el"))
(when (modulep! :lang rust) (load! "modules/rust.el"))
(when (personal-config-has-profile 'ledger) (load! "modules/hledger.el"))
(when (personal-config-has-profile 'mail) (load! "modules/mail.el"))
(when (personal-config-has-profile 'roam) (load! "modules/org-roam.el"))
