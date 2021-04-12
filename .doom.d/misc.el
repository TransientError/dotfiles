;;; misc.el -*- lexical-binding: t; -*-

(after! magit
  (defun magit-add-current-buffer ()
    "Adds (with force) the file from the current buffer to the git repo"
    (interactive)
    (shell-command (concat "git add -f "
                   (shell-quote-argument buffer-file-name)))))

