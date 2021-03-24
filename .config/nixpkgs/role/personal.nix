{ pkgs, lib, ... }:
let
  hardwareInfo = import ../utils/hardwareInfo.nix {inherit lib;};
in {
  home.file.".cargo/config".source = ../extraConfigs/cargo/config;

  home.packages = with pkgs;
    [
      lorri
      imagemagick
      cargo-audit
      cargo-edit
      cargo-outdated
      cargo-udeps
      cargo-update
      aria2
      # rustup is not really compatible with the glibc I'm using anymore
      nodejs
      nodePackages.npm
    ] ++ (if hardwareInfo.os == "linux" then [ sccache ] else [ ]);

  programs.git = { userEmail = "kvwu@transienterror.com"; };
}
