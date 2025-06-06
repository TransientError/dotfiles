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
          ["https://mail.proton.me"] = {
            selector = "#rooster-editor"
          },
          ["https://web.whatsapp.com/"] = {
            takeover = "never"
          },
          ["https://messages.google.com/"] = {
            takeover = "never"
          },
          ["https://www.google.com/"] = {
            takeover = "never"
          },
          ["https://discord.com/"] = {
            takeover = "never"
          }
        }
      }
      vim.keymap.set("i", "<C-v>", '"+p')
    end
  },
}
