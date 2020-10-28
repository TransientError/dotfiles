{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "kvwu";
  home.homeDirectory = "/home/kvwu";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.09";

  programs.neovim = {
    enable = true;
    extraConfig = builtins.readFile /home/kvwu/.config/nvim/init.vim;

    plugins = with pkgs.vimPlugins; [ vim-nix ];
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    extraConfig = builtins.readFile extraConfigs/.tmux.conf;

    plugins = with pkgs.tmuxPlugins; [ yank ];
  };
}
