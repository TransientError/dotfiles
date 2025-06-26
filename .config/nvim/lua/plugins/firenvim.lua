return {
  {
    "glacambre/firenvim",
    build = ":call firenvim#install(0)",
    cond = function ()
      return vim.g.started_by_firenvim
    end,
    config = function ()
      vim.g.firenvim_config = {
        localSettings = {
          [".*"] = {
            takeover = "never"
          },
        }
      }
      vim.keymap.set("i", "<C-v>", '"+p')
    end
  },
}
