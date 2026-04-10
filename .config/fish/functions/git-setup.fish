function git-setup
    if test (count $argv) -eq 0
        echo "Usage: gs <repo-url>"
        return 1
    end

    set -l repo_name (string replace -r '.*[/:]([^/]+?)(?:\.git)?/?$' '$1' $argv[1])

    mkdir $repo_name
    git clone --bare $argv[1] $repo_name/$repo_name-git

    # Bare clone omits fetch refspec — add it so future fetches work
    git --git-dir=$repo_name/$repo_name-git config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
    git --git-dir=$repo_name/$repo_name-git fetch origin

    # .git pointer so git commands work from project root
    echo "gitdir: ./$repo_name-git" > $repo_name/.git

    set -l default_branch (git --git-dir=$repo_name/$repo_name-git symbolic-ref refs/remotes/origin/HEAD | string replace 'refs/remotes/origin/' '')
    set -l normalized_branch (string replace -a '/' '-' $default_branch)

    cd $repo_name
    git worktree add $normalized_branch $default_branch
    git -C $normalized_branch branch --set-upstream-to=origin/$default_branch
end

