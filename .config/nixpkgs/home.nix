{ config, pkgs, lib, ... }:

with lib;

let
  defaultConfig = import ./config-defaults.nix;
  configPath = ./config.nix;
  myConfig = if builtins.pathExists configPath then
    defaultConfig // import configPath
  else
    defaultConfig;

  name = let envUser = builtins.getEnv "USER";
  in if builtins.stringLength envUser > 0 then envUser else "kvwu";
  homeDir = let envHome = builtins.getEnv "HOME";
  in if builtins.stringLength envHome != 0 then
    envHome
  else if myLib.os == "linux" then
    "/home/kvwu"
  else if myLib.os == "darwin" then
    "/Users/kvwu"
  else
    throw "Couldn't determine home directory, please set $HOME";

  hardwareInfo = let attrsAsList = strings.splitString "-" builtins.currentSystem;
  in {
    arch = elemAt attrsAsList 0;
    os = elemAt attrsAsList 1;
  };
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

  home.packages = with pkgs; [ nixfmt parallel ];

  programs.neovim = {
    enable = true;
    extraConfig = builtins.readFile extraConfigs/nvim/init.vim;

    plugins = with pkgs.vimPlugins; [ vim-nix neoformat ];
  };

  programs.tmux = if myConfig.remote then {
    enable = true;
    clock24 = true;
    extraConfig = builtins.readFile extraConfigs/.tmux.conf;

    plugins = with pkgs.tmuxPlugins; [ yank ];
  } else
    { };

  imports = let 
    os = hardwareInfo.os;
    hostname = builtins.getEnv "hostname";
    role = myConfig.role;
  in
    builtins.filter builtins.pathExists [ (./os + "${os}.nix") (./role + "/${role}.nix") (./hosts + "${hostname}.nix") ];
}
