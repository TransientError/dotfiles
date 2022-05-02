(when (featurep! :kvwu ledger)
  (use-package! hledger-mode
    :after ivy
    :init
    (set-company-backend! 'hledger-mode 'hledger-company)
    (add-to-list 'auto-mode-alist '("\\.journal\\'" . hledger-mode))
    (setq-hook! 'hledger-mode-hook +format-with 'ledger-mode)
    (add-hook! 'hledger-mode-hook #'display-line-numbers--turn-on)
    (defun kvwu/hledger-balance ()
      (interactive)
      (let* ((inhibit-read-only t)
             (output-buffer (hledger-jdo (format "accounts -f %s" (buffer-file-name)) nil t))
             (accounts (split-string (with-current-buffer output-buffer (buffer-string)))))
        (ivy-read "" accounts :action
                  (lambda (account) (hledger-jdo (format "register %s --auto -f %s" account (buffer-file-name)))))))
    (map! :leader :desc "ledger" "X l" (cmd! () (find-file "~/Dropbox/ledgers/ledger.journal"))
      (:after ledger-mode :map hledger-mode-map
        :localleader "f" #'ledger-mode-clean-buffer)
      (:after hledger-mode :map hledger-mode-map
        :localleader "d" #'hledger-run-command
        :localleader "p" (cmd! () (hledger-jdo (format "print --auto -f %s" (buffer-file-name))))
        :localleader "r" #'kvwu/hledger-balance))
    :config
    (setq! hledger-jfile "~/Dropbox/ledgers/ledger.journal"
           hledger-currency-string "$")))

(use-package! flycheck-hledger
  :when (featurep! :checkers syntax)
  :after hledger-mode)
