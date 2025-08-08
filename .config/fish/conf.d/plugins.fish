if status is-interactive
  if test -z "$MSYSTEM" 
    if test -e "$HOME/.nix-profile/etc/profile.d/nix.fish"
        source "$HOME/.nix-profile/etc/profile.d/nix.fish"
    else if test -d '/nix/var/nix/profiles/default/etc/profile.d/'
      source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
    else if test -e "$HOME/.nix-profile/etc/profile.d/nix.sh"
        bass ". $HOME/.nix-profile/etc/profile.d/nix.sh"
    end
    bass ". $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
  end

  if type -q pyenv
    status is-interactive; and pyenv init --path | source
    pyenv init - | source
  end

  if type -q starship
    starship init fish | source
  end

  if type -q direnv
    eval (direnv hook fish)
  end

  if type -q bun
    set --export BUN_INSTALL "$HOME/.bun"
    set --export PATH $BUN_INSTALL/bin $PATH
  end

  if type -q zoxide
    zoxide init fish | source
  end
end
