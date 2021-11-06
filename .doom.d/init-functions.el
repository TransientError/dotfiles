;;; init-functions.el -*- lexical-binding: t; -*-

(defun get-personal-config (key)
  (when (boundp 'kvwu-personal-config)
    (plist-get kvwu-personal-config key)))

(defun personal-config-has-profile (profile)
  (when (boundp 'kvwu-personal-config)
    (memq profile (get-personal-config 'profiles))))
