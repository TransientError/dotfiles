function gs
  set -l repo_name (string replace -r '.*[/:]([^/]+)(?:\.git)?/?$' '$1' $argv[1])

  mkdir $repo_name
  git clone --bare $argv[1] $repo_name/$repo_name.git

  set -l default_branch (git --git-dir=$repo_name/$repo_name.git symbolic-ref refs/remotes/origin/HEAD | string replace 'refs/remotes/origin/' '')

  set -l normalized_branch (string replace '/' '-' $default_branch)

  git --git-dir=$repo_name/$repo_name.git worktree add $repo_name/$normalized_branch $default_branch
end

