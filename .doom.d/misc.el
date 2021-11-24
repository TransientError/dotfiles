;;; misc.el -*- lexical-binding: t; -*-

(after! magit
  (defun kvwu/magit-add-current-buffer ()
    "Adds (with force) the file from the current buffer to the git repo"
    (interactive)
    (shell-command (concat "git add -f " (shell-quote-argument buffer-file-name)))))


(defun kvwu/which-linux-distribution ()
  "from lsb_release"
  (interactive)
  (when (eq system-type 'gnu/linux) (shell-command-to-string "lsb_release -sd")))

(defun kvwu/is-wsl ()
  (when (executable-find "uname") (string-match-p "-[Mm]icrosoft" (shell-command-to-string "uname -a"))))

(defun ap/garbage-collect ()
  "Run `garbage-collect' and print stats about memory usage."
  (interactive)
  (message (cl-loop for (type size used free) in (garbage-collect)
                    for used = (* used size)
                    for free = (* (or free 0) size)
                    for total = (file-size-human-readable (+ used free))
                    for used = (file-size-human-readable used)
                    for free = (file-size-human-readable free)
                    concat (format "%s: %s + %s = %s\n" type used free total))))
