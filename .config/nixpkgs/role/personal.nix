{ pkgs, ... }: {

  home.file.".cargo/config".source = ../extraConfigs/cargo/config;

  home.packages = with pkgs; [
    direnv
    lorri
    imagemagick
    cargo-audit
    cargo-edit
    cargo-outdated
    aria2
    sccache
    rustup
    nodejs
    nodePackages.npm
  ];

  programs.git = { userEmail = "kvwu@transienterror.com"; };
}
