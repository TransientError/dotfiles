{ config, pkgs, lib, ... }:

with lib;

let
  defaultConfig = import ./config-defaults.nix;
  configPath = ./config.nix;
  myConfig = if builtins.pathExists configPath then
    defaultConfig // import configPath
  else
    defaultConfig;

  hardwareInfo = (import utils/hardwareInfo.nix) {inherit lib;};

  name = let envUser = builtins.getEnv "USER";
  in if builtins.stringLength envUser > 0 then envUser else "kvwu";
  homeDir = let envHome = builtins.getEnv "HOME";
  in if builtins.stringLength envHome != 0 then
    envHome
  else if hardwareInfo.os == "linux" then
    "/home/kvwu"
  else if hardwareInfo.os == "darwin" then
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

  home.packages = with pkgs;
    with gitAndTools; [
      nixfmt
      parallel
      cargo-update
      dua
      exa
      diff-so-fancy
      fd
      fasd
      fzf
      ripgrep
      cht-sh
      jq
      curlie
      # need to figure out how to get runtime dependency to work
      # duplicity
      htop
      poetry
      uq
      direnv
    ];

  programs.neovim = {
    enable = true;
    extraConfig = builtins.readFile extraConfigs/nvim/init.vim;

    plugins = with pkgs.vimPlugins; [
      vim-nix
      neoformat
      lightline-vim
      fzf-vim
      emmet-vim
      vim-closetag
      vim-surround
      vim-fish
      vim-commentary
      ReplaceWithRegister
      vim-toml
    ];
  };

  programs.git = {
    enable = true;

    userName = "kvwu";

    extraConfig = {
      alias = {
        lg =
          "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all";
        tree =
          "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all";
      };
      core = {
        pager = "diff-so-fancy | less --tabs=4 -RFX";
        editor = "nvim";
        excludesfile = homeDir
          + "/.config/nixpkgs/extraConfigs/git/gitignore_global";
      };
      color.diff.meta = 11;
      pull.rebase = true;
      rebase.autoStash = true;
    };
  };

  programs.starship = {
    enable = true;

    enableFishIntegration = true;
    settings = { add_newline = false; };
  };

  programs.bat = {
    enable = true;

    config = { theme = "OneHalfDark"; };
  };

  home.file.".config/kitty/theme.conf".source = extraConfigs/kitty/theme.conf;
  home.file.".config/kitty/kitty.conf".source =
    extraConfigs/kitty/kitty-base.conf;

  imports = let
    os = hardwareInfo.os;
    hostname = builtins.getEnv "hostname";
    role = myConfig.role;
    profiles = myConfig.profiles;
  in builtins.filter builtins.pathExists (flatten [
    [ (./os + "/${os}.nix") ]
    [ (./role + "/${role}.nix") ]
    (map (profile: (./profiles + "/${profile}.nix")) profiles)
    [ (./hosts + "/${hostname}.nix") ]
  ]);
}
