function git-workspace-create
    if test (count $argv) -eq 0
        echo "Usage: gwc <branch-name>"
        return 1
    end

    set -l branch_name $argv[1]
    set -l normalized_branch (string replace -a '/' '-' $branch_name)

    # Resolve project root from the bare repo location
    set -l git_common_dir (git rev-parse --git-common-dir)
    set -l project_root (dirname $git_common_dir)
    set -l worktree_path $project_root/$normalized_branch

    if git show-ref --verify --quiet refs/heads/$branch_name
        # Local branch already exists
        git worktree add $worktree_path $branch_name
    else
        set -l remote_branch (git branch -r --list "origin/$branch_name" | string trim)
        if test -n "$remote_branch"
            # Create local branch tracking remote
            git worktree add --track -b $branch_name $worktree_path $remote_branch
        else
            # New branch from current HEAD
            git worktree add -b $branch_name $worktree_path
        end
    end
end
