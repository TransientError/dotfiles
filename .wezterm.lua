local wezterm = require "wezterm" --[[@as Wezterm]]
local config = wezterm.config_builder()

local tabline = wezterm.plugin.require "https://github.com/michaelbrusegard/tabline.wez"
tabline.setup { options = { theme = "Tomorrow Night Bright" } } ---@diagnostic disable-line: undefined-field
tabline.apply_to_config(config)
config.window_decorations = "TITLE | RESIZE"
config.tab_bar_at_bottom = true

if wezterm.target_triple == "x86_64-unknown-linux-gnu" then
  config.color_scheme = "PaulMillr"
  config.launch_menu = {
    {
      label = "Nushell",
      args = { "nu" },
    },
    {
      label = "Fish",
      args = { "fish" },
    },
  }
elseif wezterm.target_triple == "aarch64-apple-darwin" then
  config.enable_kitty_keyboard = true
  config.enable_csi_u_key_encoding = true
end

config.font = wezterm.font "LigaHack Nerd Font"
config.font_size = 11

local keys = require "keys"
keys.apply_to_config(config)

return config
