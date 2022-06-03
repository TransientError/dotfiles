;;; python.el -*- lexical-binding: t; -*-
(after! python
  (setq-hook! #'python-mode-hook tab-width 4)
  (defun pipx-install ()
    (interactive)
    (shell-command (concat "pipx install --force " (projectile-acquire-root))))
  (setq! poetry-tracking-strategy 'projectile lsp-pyright-venv-path "/home/kvwu/.cache/pypoetry/virtualenvs")
  (map! :map python-mode-map :leader :n "m p" #'poetry :leader :n "m n" #'pipx-install))
