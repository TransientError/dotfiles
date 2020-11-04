{ pkgs, ... }: {
  home.file.".config/kitty/kitty-os.conf".source = ../extraConfigs/kitty/kitty-linux.conf;

  home.packages = with pkgs; [
    glibcLocales
  ];
}
