{ ... }: {
  home.file.".config/kitty/kitty-os.conf".source =
    ../extraConfigs/kitty/kitty-darwin.conf;
}
