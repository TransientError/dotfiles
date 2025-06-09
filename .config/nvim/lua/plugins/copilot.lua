if require("utils").minimal() then
  return {}
end

return {
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    cmd = { "Copilot" },
    opts = function()
      local prefix = vim.fn.has "mac" == 1 and "D" or "C"
      return {
        suggestion = {
          auto_trigger = true,
          keymap = {
            accept_word = string.format("<%s-right>", prefix),
            accept_line = string.format("<%s-S-right>", prefix),
          },
        },
        panel = {
          auto_refresh = true,
        }
      }
    end,
    keymap = {
      {
        "<right>",
        function()
          local suggestion = require "copilot.suggestion"
          if suggestion.is_visible() then
            suggestion.accept()
          else
            return "<right>"
          end
        end,
        mode = "i",
      },
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = {
      "CopilotChat",
      "CopilotChatOpen",
      "CopilotChatToggle",
      "CopilotChatReset",
      "CopilotChatSave",
      "CopilotChatLoad",
      "CopilotChatPrompts",
    },
    opts = {},
  },
}
