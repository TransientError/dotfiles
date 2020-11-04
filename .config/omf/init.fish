starship init fish | source
bass '. $HOME/.nix-profile/etc/profile.d/nix.sh'
bass '. $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh'

if type -q direnf
  eval (direnv hook fish)
end
