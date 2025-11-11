function add-remote-branch
    if test (count $argv) -ne 2
        echo "Usage: add-remote-branch <remote> <branch>"
        return 1
    end

    set remote $argv[1]
    set branch $argv[2]

    git config --add remote.$remote.fetch "+refs/heads/$branch:refs/remotes/$remote/$branch"
    git fetch $remote $branch
end
