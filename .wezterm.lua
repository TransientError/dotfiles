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

config.leader = { key = ",", mods = "CTRL" }
config.keys = {
  {
    key = "c",
    mods = "CTRL",
    action = wezterm.action_callback(function(window, pane)
      if pane == nil then
        wezterm.log_error "pane is nil"
        return
      end
      local selection_text = window:get_selection_text_for_pane(pane)
      local is_selection_active = string.len(selection_text) ~= 0
      if is_selection_active then
        window:perform_action(wezterm.action.CopyTo "ClipboardAndPrimarySelection", pane)
      else
        window:perform_action(wezterm.action.SendKey { key = "c", mods = "CTRL" }, pane)
      end
    end),
  },
  {
    key = "l",
    mods = "LEADER",
    action = wezterm.action.ShowLauncher,
  },
  {
    key = "s",
    mods = "LEADER",
    action = wezterm.action.QuickSelect,
  },
  {
    key = "c",
    mods = "LEADER",
    action = wezterm.action.ActivateCopyMode,
  },
  {
    key = "j",
    mods = "LEADER",
    action = wezterm.action.ActivateCommandPalette,
  },
  {
    key = "v",
    mods = "CTRL",
    action = wezterm.action.PasteFrom "Clipboard",
  },
  {
    key = "w",
    mods = "CTRL",
    action = wezterm.action.CloseCurrentTab { confirm = true },
  },
  {
    key = "t",
    mods = "CTRL",
    action = wezterm.action.SpawnTab "CurrentPaneDomain",
  },
}

return config
