{ pkgs, lib, ... }:
with lib; {
  home.packages = with pkgs; [ powerline ];

  programs.tmux = {
    enable = true;
    clock24 = true;
    extraConfig = let
      sources = [ "${pkgs.powerline}/share/tmux/powerline.conf" ];
      sourcesString =
        pipe sources [ (map (p: "source " + p)) (concatStringsSep "\n") ];
    in sourcesString + "\n" + builtins.readFile ../extraConfigs/.tmux.conf;

    plugins = with pkgs.tmuxPlugins; [ yank ];
  };
}
