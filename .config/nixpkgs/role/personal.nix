{ pkgs, ... }: {

  home.file.".cargo/config".source = ../extraConfigs/cargo/config;

  home.packages = with pkgs; [
    lorri
    imagemagick
    cargo-audit
    cargo-edit
    cargo-outdated
    cargo-udeps
    cargo-update
    aria2
    sccache
    # rustup is not really compatible with the glibc I'm using anymore
    nodejs
    nodePackages.npm
  ];

  programs.git = { userEmail = "kvwu@transienterror.com"; };
}
