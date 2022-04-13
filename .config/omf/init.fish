if test -z "$ZSH_AUTO_RAN_FISH" 
  bass '. $HOME/.nix-profile/etc/profile.d/nix.sh'
  bass '. $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh'
end

starship init fish | source

if type -q direnv
  eval (direnv hook fish)
end

if test "$TERM" = "xterm-kitty"
  abbr -g icat kitty +kitten icat
  abbr -g kssh kitty +kitten ssh
  abbr -g kdiff kitty +kitten diff
end

if test "$TERM" = "dumb"
  function fish_prompt
    echo "\$"
  end
end


