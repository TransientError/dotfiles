{ config, pkgs, lib, ... }:

with lib;

let
  callPackage = pkgs.callPackage;
  my_config = callPackage ./config-provider.nix { };
  name = let envUser = builtins.getEnv "USER";
  in if builtins.stringLength envUser > 0 then envUser else "kvwu";
  homeDir = let envHome = builtins.getEnv "HOME";
  in if builtins.stringLength envHome != 0 then
    envHome
  else if my_config.os == "linux" then
    "/home/kvwu"
  else if my_config.os == "darwin" then
    "/Users/kvwu"
  else
    throw "Couldn't determine home directory, please set $HOME";
in {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = name;
  home.homeDirectory = homeDir;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.09";

  home.packages = with pkgs; [ nixfmt direnv lorri ];

  programs.neovim = {
    enable = true;
    extraConfig = builtins.readFile extraConfigs/nvim/init.vim;

    plugins = with pkgs.vimPlugins; [ vim-nix neoformat ];
  };

  programs.tmux = if my_config.is_remote { } then {
    enable = true;
    clock24 = true;
    extraConfig = builtins.readFile extraConfigs/.tmux.conf;

    plugins = with pkgs.tmuxPlugins; [ yank ];
  } else
    { };

}
