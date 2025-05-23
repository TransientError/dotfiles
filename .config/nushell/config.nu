# config.nu
#
# Installed by:
# version = "0.104.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options
#
# You can remove these comments if you want or leave
# them for future reference.

if (which starship | is-not-empty) {
  mkdir ($nu.data-dir | path join "vendor/autoload")
  starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
}

source ~/.cache/carapace/init.nu

source ~/.zoxide.nu

match $nu.os-info.name {
  "linux" => {
    alias trash = gio trash
    alias config = git --git-dir $env.HOME/utils/dotfiles.git --work-tree $env.HOME
  }
}
