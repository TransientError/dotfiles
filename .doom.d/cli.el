(unless (featurep! :kvwu aot) (advice-add #'native-compile-async :override #'ignore))
