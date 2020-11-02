{ pkgs, ... }:
with pkgs.lib;
let
  configurations = import ./config.nix;
  cs = let attrsAsList = strings.splitString "-" builtins.currentSystem;
  in {
    arch = elemAt attrsAsList 0;
    os = elemAt attrsAsList 1;
  };
in with cs; {
  is_remote = { }: configurations.remote or false;
  inherit os;
}
