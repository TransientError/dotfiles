if test -z "$ZSH_AUTO_RAN_FISH" 
  bass '. $HOME/.nix-profile/etc/profile.d/nix.sh'
  bass '. $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh'
end

if test $TERM != "dumb"
  starship init fish | source
end

if type -q direnv
  eval (direnv hook fish)
end

if test "$TERM" = "xterm-kitty"
  abbr -g icat kitty +kitten icat
  abbr -g kssh kitty +kitten ssh
end

if test "$TERM" = "dumb"
  function fish_prompt
    echo "\$"
  end
end

