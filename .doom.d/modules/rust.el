;;; rust.el -*- lexical-binding: t; -*-
(after! lsp-rust
  (setq! lsp-rust-server 'rust-analyzer lsp-rust-analyzer-server-display-inlay-hints t lsp-rust-clippy-preference "on"))

(add-hook! 'rustic-mode-hook #'rainbow-delimiters-mode)
