if status is-interactive
    # Commands to run in interactive sessions can go here
  if test -z "$MSYSTEM" 
    bass '. $HOME/.nix-profile/etc/profile.d/nix.sh'
    bass '. $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh'
  end

  if type -q starship
    starship init fish | source
  end

  if type -q direnv
    eval (direnv hook fish)
  end

  if test "$TERM" = "xterm-kitty"
    abbr -g icat kitty +kitten icat
    abbr -g kssh kitty +kitten ssh
    abbr -g kdiff kitty +kitten diff
  end

end

if test "$TERM" = "dumb"
  function fish_prompt
    echo "\$"
  end
end


