;;; misc.el -*- lexical-binding: t; -*-

(after! magit
  (defun kvwu/magit-add-current-buffer ()
    "Adds (with force) the file from the current buffer to the git repo"
    (interactive)
    (shell-command (concat "git add -f " (shell-quote-argument buffer-file-name)))))


(defun kvwu/which-linux-distribution ()
  "from lsb_release"
  (interactive)
  (when (eq system-type 'gnu/linux)
    (shell-command-to-string "lsb_release -sd")))
