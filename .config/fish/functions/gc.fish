function gc
  # Check if repo path was passed as argument
  if test (count $argv) -gt 0
    set -l repo_path $argv[1]
    # TODO: Handle passed repo path
    mv $repo_path $repo_path.git
    mkdir $repo_path
    mv $repo_path/.git $repo_path/$repo_path.git
    cd $repo_path
    set -l current_branch (git --git-dir=$repo_path/$repo_path.git branch --show-current)
    git --git-dir=$repo_path/$repo_path.git config core.bare true
    git --git-dir=$repo_path/$repo_path.git worktree add $current_branch
  else
    # TODO: Handle current directory as repo
    set -l repo_name (basename (pwd))
    set -l current_branch (git branch --show-current)
    mv .git $repo_name.git
    git --git-dir=$repo_name.git config core.bare true
    git --git-dir=$repo_name.git worktree add $current_branch
  end
end

