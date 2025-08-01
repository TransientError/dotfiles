if status is-interactive
  if test "$TERM" = "xterm-kitty"
    abbr -g icat kitty +kitten icat
    abbr -g kssh kitty +kitten ssh
    abbr -g kdiff kitty +kitten diff
  end

  if type -q eza
    abbr ls eza
  end

  if type -q gio
    abbr trash "gio trash"
  end

  if test -e $HOME/utils/dotfiles.git
    abbr config 'git --git-dir $HOME/utils/dotfiles.git --work-tree=$HOME'
    abbr lconfig 'lazygit -g $HOME/utils/dotfiles.git -w $HOME'
  else
    abbr config 'git --git-dir $HOME/utils/dotfiles/.git --work-tree=$HOME'
    abbr lconfig 'lazygit -g $HOME/utils/dotfiles/.git -w $HOME'
  end

  if type -q /opt/docfx/docfx
    alias docfx /opt/docfx/docfx 
  end

  if type -q gh
    abbr sug 'gh copilot suggest -t shell'
  end

  if type -q nvim
    set -gx EDITOR nvim
  end
end
