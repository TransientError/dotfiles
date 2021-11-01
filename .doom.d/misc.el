;;; misc.el -*- lexical-binding: t; -*-

(after! magit
  (defun magit-add-current-buffer ()
    "Adds (with force) the file from the current buffer to the git repo"
    (interactive)
    (shell-command (concat "git add -f "
                   (shell-quote-argument buffer-file-name)))))

(defun get-personal-config (key)
  (when (boundp 'kvwu-personal-config)
    (plist-get kvwu-personal-config key)))

(defun personal-config-has-profile (profile)
  (when (boundp 'kvwu-personal-config)
    (memq profile (get-personal-config 'profiles))))

(defun which-linux-distribution ()
  "from lsb_release"
  (interactive)
  (when (eq system-type 'gnu/linux)
     (shell-command-to-string "lsb_release -sd")))
