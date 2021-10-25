;;; rust.el -*- lexical-binding: t; -*-
(use-package! lsp-rust
  :defer t
  :config
  (setq! lsp-rust-server 'rust-analyzer
         lsp-rust-analyzer-server-display-inlay-hints t
         lsp-rust-clippy-preference "on"))

(add-hook! 'rustic-mode-hook #'rainbow-delimiters-mode)
