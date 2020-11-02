{ pkgs, ... }: {

  home.file.".cargo/config".source = ../extraConfigs/cargo/config; 

  home.packages = with pkgs; with gitAndTools; [
    direnv
    lorri
    imagemagick
    cargo-audit
    cargo-edit
    cargo-outdated
    aria2
    sccache
    rustup
  ];
}
