(unless (personal-config-has-profile 'aot) (advice-add #'native-compile-async :override #'ignore))
