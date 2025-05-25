local wezterm = require "wezterm" --[[@as Wezterm]]
local config = wezterm.config_builder()

local tabline = wezterm.plugin.require "https://github.com/michaelbrusegard/tabline.wez"
tabline.setup { options = { theme = "Tomorrow Night Bright" } } ---@diagnostic disable-line: undefined-field
tabline.apply_to_config(config)
config.window_decorations = "TITLE | RESIZE"
config.tab_bar_at_bottom = true

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  config.default_prog = { "pwsh" }
  config.color_scheme = "Campbell (Gogh)"

  config.launch_menu = {
    {
      label = "Powershell",
      args = { "pwsh" },
    },
  }
elseif wezterm.target_triple == "x86_64-unknown-linux-gnu" then
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
end

config.font = wezterm.font "LigaHack Nerd Font"
config.font_size = 11


local keys = require "keys"
keys.apply_to_config(config)

return config
