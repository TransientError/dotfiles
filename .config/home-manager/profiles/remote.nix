{ pkgs, lib, ... }:
with lib; 
let
  defaultConfig = import ../config-defaults.nix;
  configPath = ../config.nix;
  myConfig = if builtins.pathExists configPath then
    defaultConfig // import configPath
  else
    defaultConfig;
in
{
  home.packages = with pkgs; [
    reptyr
  ];

  home.file.".config/powerline" = {
    source = ../extraConfigs/powerline;
    recursive = true;
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    terminal = "screen-256color";
    keyMode = "vi";
    extraConfig = let
      sources = [ myConfig.powerlineTmuxSrc ];
      sourcesString =
        pipe sources [ (map (p: "source " + p)) (concatStringsSep "\n") ];
    in sourcesString + "\n" + builtins.readFile ../extraConfigs/.tmux.conf;

    plugins = with pkgs.tmuxPlugins; [ yank ];
  };
}
