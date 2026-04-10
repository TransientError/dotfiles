function git-workspace-setup
    if test (count $argv) -gt 0
        cd $argv[1]
    end

    set -l repo_name (basename (pwd))
    set -l current_branch (git branch --show-current)
    set -l remote_branch (git rev-parse --abbrev-ref $current_branch@{upstream} 2>/dev/null)

    # Abort if working tree is dirty
    if not git diff --quiet || not git diff --cached --quiet
        echo "gws: working tree has uncommitted changes, aborting"
        return 1
    end

    # Convert .git directory to bare repo
    mv .git $repo_name-git
    git --git-dir=$repo_name-git config core.bare true
    git --git-dir=$repo_name-git config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'

    # Create .git pointer file
    echo "gitdir: ./$repo_name-git" > .git

    # Clean working tree files (they'll live in the worktree)
    for f in *
        if test "$f" != "$repo_name-git"
            rm -rf $f
        end
    end
    for f in .*
        if test "$f" != ".git" -a "$f" != "." -a "$f" != ".."
            rm -rf $f
        end
    end

    # Create worktree for the branch we were on
    set -l normalized_branch (string replace -a '/' '-' $current_branch)
    git worktree add $normalized_branch $current_branch

    if test -n "$remote_branch"
        git -C $normalized_branch branch --set-upstream-to=$remote_branch
    end
end

