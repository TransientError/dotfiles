let configurations = import ./config.nix; in
{
    is_remote = {}: configurations.remote or false;
}