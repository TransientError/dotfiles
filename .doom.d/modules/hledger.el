(when (featurep! :kvwu ledger)
  (use-package! hledger-mode
    :after ivy display-line-numbers
    :init
    (set-company-backend! 'hledger-mode 'hledger-company)
    (add-to-list 'auto-mode-alist '("\\.journal\\'" . hledger-mode))
    (setq-hook! 'hledger-mode-hook +format-with 'ledger-mode)
    (add-hook! 'hledger-mode-hook #'display-line-numbers-mode)
    (defun kvwu/hledger-balance ()
      (interactive)
      (let* ((inhibit-read-only t)
             (output-buffer (hledger-jdo (format "accounts -f %s" (buffer-file-name)) nil t))
             (accounts (split-string (with-current-buffer output-buffer (buffer-string)))))
        (ivy-read "" accounts :action
                  (lambda (account) (hledger-jdo (format "register %s --auto" account))))))
    (map! :leader :desc "ledger" "X l" (cmd! () (find-file "~/Dropbox/ledgers/ledger.journal")))
    :config
    (setq! hledger-jfile "~/Dropbox/ledgers/ledger.journal"
           hledger-currency-string "$")
    (evil-make-intercept-map hledger-view-mode-map)
    (map!
     (:after ledger-mode :map hledger-mode-map
      :localleader "f" #'ledger-mode-clean-buffer)
     (:after hledger-mode :map hledger-mode-map
      :localleader "d" #'hledger-run-command
      :localleader "p" (defun kvwu/hledger-print ()
                         (interactive)
                         (let* ((inhibit-read-only t)) (hledger-jdo "print --auto")))
      :localleader "r" (defun kvwu/hledger-balance ()
                         (interactive)
                         (let* ((inhibit-read-only t))
                           (output-buffer (hledger-jdo (format "accounts -f %s" (buffer-file-name)) nil t))
                           (accounts (split-string (with-current-buffer output-buffer (buffer-string))))
                           (ivy-read "" accounts :action
                                     (lambda (account) (hledger-jdo (format "register %s --auto" account)))))))))

  (use-package! flycheck-hledger
    :when (featurep! :checkers syntax)
    :after hledger-mode
    :demand t))
