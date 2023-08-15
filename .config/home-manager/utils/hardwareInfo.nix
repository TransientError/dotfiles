{ lib, ... }:
with lib;
let attrsAsList = strings.splitString "-" builtins.currentSystem;
in {
  arch = elemAt attrsAsList 0;
  os = elemAt attrsAsList 1;
}
