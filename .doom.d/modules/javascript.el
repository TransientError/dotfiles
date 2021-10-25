;;; javascript.el -*- lexical-binding: t; -*-
(add-to-list 'auto-mode-alist '("\\.jsx?$" . web-mode))
(after! web-mode
  (map! :map emmet-mode-map :leader :n "m E" #'emmet-expand-line))

(use-package! js2-mode
  :after web-mode
  :defer t
  :config
  (setq! web-mode-content-types-alist '(("jsx" . "\\.js[x]?\\'")))
  (setq! web-mode-markup-indent-offset 2))
