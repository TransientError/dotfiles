{ pkgs, ... }: {
  home.packages = with pkgs; [
    glibcLocales
    procs
  ];
}
