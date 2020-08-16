# Defined in - @ line 1
function config --wraps='/usr/bin/git --git-dir=$HOME/utils/dotfiles/ --work-tree=$HOME' --description 'alias config=/usr/bin/git --git-dir=$HOME/utils/dotfiles/ --work-tree=$HOME'
  /usr/bin/git --git-dir=$HOME/utils/dotfiles/ --work-tree=$HOME $argv;
end
