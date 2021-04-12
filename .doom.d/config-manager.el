;;; config-manager.el -*- lexical-binding: t; -*-

(defun set-gitptr ()
  (interactive)
  (let ((home (getenv "HOME")))
        (rename-file (expand-file-name ".gitptr" home) (expand-file-name ".git" home))))

(defun unset-gitptr ()
  (interactive)
  (let ((home (getenv "HOME")))
    (rename-file (expand-file-name ".git" home) (expand-file-name ".gitptr" home))))
