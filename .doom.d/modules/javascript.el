;;; javascript.el -*- lexical-binding: t; -*-
(add-to-list 'auto-mode-alist '("\\.jsx?$" . web-mode))
(after! web-mode
  (map! :map emmet-mode-map :leader :n "m E" #'emmet-expand-line))

(use-package! js2-mode
  :after web-mode
  :config
  (setq! web-mode-content-types-alist '(("jsx" . "\\.js[x]?\\'"))
         web-mode-markup-indent-offset 2))

(after! (dap-mode typescript-mode)
  (dap-register-debug-template
   "Typescript Launch"
   (list :type "node"
         :request "launch"
         :args "${file}"
         :runtimeArgs ["-nolazy""-r" "ts-node/register" "--loader" "ts-node/esm.mjs"]
         :cwd "${fileDirname}"
         :protocol "inspector"
         :sourceMaps "true")))

;; typescript
(setq-hook! typescript-mode-hook tab-width 2 typescript-indent-level 2)
