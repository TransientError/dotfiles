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

(defun kvwu/wsl-browser (browser)
  (let* ((program-files-path "/mnt/c/Program Files/")
         (program-files-x86-path "/mnt/c/Program Files (x86)/")
         (windows-home "/mnt/c/Users/wukevin/")
         (scoop-bin (concat windows-home "scoop/shims/")))
    (pcase browser
      ('firefox (concat program-files-path "/Mozilla Firefox/firefox.exe"))
      ('chrome (concat program-files-path "Google/Chrome/Application/chrome.exe"))
      ('scoop-chrome (concat scoop-bin "chrome.exe"))
      ('edge (concat program-files-x86-path "Microsoft/Edge/Application/msedge.exe")))))

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

(setq kvwu/secrets-dir (concat (getenv "HOME") "/.secrets"))

(defun kvwu/get-secret (secret-name)
  (string-trim
   (shell-command-to-string (concat "gpg -q --for-your-eyes-only --no-tty -d " kvwu/secrets-dir "/" secret-name))))

(defun kvwu/is-interesting-file (path)
  (not (member path '("." ".."))))

(defun kvwu/list-secrets ()
  "List the secrets we have in our secrets directory and copy the name into the kill-ring, for making development
   easier"
  (interactive)
  (kill-new (ivy-read "" (seq-filter 'kvwu/is-interesting-file (directory-files kvwu/secrets-dir)))))

(after! evil
  (defun kvwu/unescape ()
    (interactive)
    (let* ((selection (evil-visual-range))
           (start (nth 0 selection))
           (end (nth 1 selection)))
      (replace-regexp-in-region (rx "\\" (group (or "\""))) "\\1" start end)
      (replace-regexp-in-region (rx (opt "\\r") "\\n") "\n" start end))))
