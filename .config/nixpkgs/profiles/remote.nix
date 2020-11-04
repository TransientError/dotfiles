{pkgs, ...}:
{
  programs.tmux = {
    enable = true;
    clock24 = true;
    extraConfig = builtins.readFile ../extraConfigs/.tmux.conf;

    plugins = with pkgs.tmuxPlugins; [ yank ];
  };
}
