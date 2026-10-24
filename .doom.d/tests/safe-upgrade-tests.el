;;; safe-upgrade-tests.el -*- lexical-binding: t; -*-

(require 'ert)
(require 'cl-lib)
(require 'subr-x)
(provide 'doom-packages)

(defun personal-config-has-profile (_) t)
(defmacro print! (&rest _) nil)
(defmacro exit! (&rest args)
  `(throw 'test-restart (delq nil (list ,@args))))
(defmacro defcli! (_name _options _doc &rest body)
  `(defun test-safe-upgrade
       (&optional buffer-days dry-run? no-sync? aot? jobs nobuild? context)
     ,@body))
(load (expand-file-name "../cli.el" (file-name-directory load-file-name)) nil t)

(defvar doom-emacs-dir temporary-file-directory)
(defvar test-calls)
(defvar test-fail-command)
(defvar test-dirty)
(defvar test-ancestor-status)
(defvar test-target)
(defvar test-current)

(defun test-git (command &rest args)
  (should (equal command "git"))
  (push args test-calls)
  (if (equal (car args) test-fail-command)
      '(128 . "simulated Git failure")
    (pcase (car args)
      ("rev-parse" (cons 0 (if (equal (cadr args) "HEAD") test-current test-target)))
      ("symbolic-ref" '(0 . "refs/remotes/origin/master"))
      ("log" '(0 . "commit metadata"))
      ("rev-list" (cons 0 (if (equal (cadr args) "-1") test-target "1")))
      ("merge-base" (cons test-ancestor-status ""))
      ("status" (cons 0 test-dirty))
      ((or "fetch" "checkout" "submodule") '(0 . ""))
      ("--no-pager" '(0 . "commit log"))
      (_ (ert-fail (format "Unexpected Git arguments: %S" args))))))

(defmacro test-with-git (&rest body)
  `(let ((test-calls nil)
         (test-fail-command nil)
         (test-dirty "")
         (test-ancestor-status 1)
         (test-current (make-string 40 ?a))
         (test-target (make-string 40 ?b)))
     (cl-letf (((symbol-function 'doom-call-process) #'test-git))
       ,@body)))

(ert-deftest dry-run-does-not-checkout-or-sync ()
  (test-with-git
   (test-safe-upgrade nil t)
   (should-not (assoc "checkout" test-calls))
   (should-not (assoc "submodule" test-calls))))

(ert-deftest upgrade-initializes-pinned-submodules-before-restarting-sync ()
  (test-with-git
   (should (equal (catch 'test-restart
                    (test-safe-upgrade "7" nil nil t 4 t))
                  '("doom" "sync" "-u" "--aot" "-B" "--jobs=4")))
   (let ((calls (reverse test-calls)))
     (should (< (cl-position "checkout" calls :key #'car :test #'equal)
                (cl-position "submodule" calls :key #'car :test #'equal))))
   (should (member '("submodule" "update" "--init" "--recursive") test-calls))))

(ert-deftest no-sync-still-initializes-submodules ()
  (test-with-git
   (should-not (test-safe-upgrade nil nil t))
   (should (assoc "checkout" test-calls))
   (should (assoc "submodule" test-calls))))

(ert-deftest dirty-working-tree-is-not-overwritten ()
  (test-with-git
   (setq test-dirty " M init.el")
   (should-error (test-safe-upgrade) :type 'user-error)
   (should-not (assoc "checkout" test-calls))))

(ert-deftest dirty-tree-check-ignores-submodule-drift ()
  (test-with-git
   (test-safe-upgrade nil nil t)
   (should (member '("status" "--porcelain" "-uno" "--ignore-submodules=all")
                   test-calls))))

(ert-deftest git-errors-abort-explicitly ()
  (dolist (command '("rev-parse" "symbolic-ref" "fetch" "checkout" "submodule"))
    (test-with-git
     (setq test-fail-command command)
     (should-error (test-safe-upgrade) :type 'user-error))))

(ert-deftest ancestry-errors-are-not-treated-as-not-ancestor ()
  (test-with-git
   (setq test-ancestor-status 128)
   (should-error (test-safe-upgrade) :type 'user-error)
   (should-not (assoc "checkout" test-calls))))

(ert-deftest no-op-revisions-do-not-checkout ()
  (dolist (state '(equal ahead empty))
    (test-with-git
     (pcase state
       ('equal (setq test-target test-current))
       ('ahead (setq test-ancestor-status 0))
       ('empty (setq test-target "")))
     (test-safe-upgrade)
     (should-not (assoc "checkout" test-calls)))))

(ert-deftest invalid-buffer-days-fails-before-git ()
  (dolist (days '("nope" "-1" "1.5" ""))
    (test-with-git
     (should-error (test-safe-upgrade days) :type 'user-error)
     (should-not test-calls))))
