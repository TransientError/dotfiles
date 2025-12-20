local utils = require("utils")
if utils.minimal() or not utils.profiles_contain("meta") then
  return {}
end

return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        "lazy.nvim",
        { path = "wezterm-types", mods = { "wezterm" } },
      },
    },
    dependencies = {
      { "TransientError/wezterm-types", lazy = true },
    },
  },
  {
    "rafcamlet/nvim-luapad",
    cmd = { "Luapad", "LuaRun" },
  },
  {
    "yuki-uthman/vimpad.nvim",
    ft = "vim",
    keys = {
      {
        "<localleader>pt",
        "<Plug>(vimpad-toggle)",
        desc = "Toggle Vimpad",
        ft = "vim",
      }
    }
  }
}
