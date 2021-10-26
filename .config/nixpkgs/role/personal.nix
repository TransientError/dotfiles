{ pkgs, lib, ... }:
let hardwareInfo = import ../utils/hardwareInfo.nix { inherit lib; };
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

  home.file.".mbsyncrc".source = if hardwareInfo.os == "darwin" then
    ../extraConfigs/mbsync/mbsyncrc-mac
  else
    ../extraConfigs/mbsync/mbsyncrc-linux;

  home.file.".msmtprc".source = if hardwareInfo.os == "darwin" then
    ../extraConfigs/msmtp/msmtp-mac
  else
    ../extraConfigs/msmtp/msmtprc-linux;
}
