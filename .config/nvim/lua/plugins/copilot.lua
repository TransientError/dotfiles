local utils = require "utils"
if utils.minimal() or not utils.profiles_contain("copilot") then
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
            accept = false,
            accept_word = string.format("<%s-right>", prefix),
            accept_line = string.format("<%s-S-right>", prefix),
          },
        },
        panel = {
          auto_refresh = true,
        },
      }
    end,
    keys = {
      {
        "<right>",
        function()
          local suggestion = require "copilot.suggestion"
          if suggestion.is_visible() then
            suggestion.accept()
          else
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<right>", true, false, true), "n", false)
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
    keys = {
      { "<leader>oc", "<cmd>CopilotChatToggle<cr>", desc = "Copilot Chat" },
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
    opts = {
      model = "claude-sonnet-4",
      sticky = {
        "#buffer"
      },
      prompts = {
        generate = {
          description = "generate boilerplate",
          system_prompt = "Generate boilerplate for this file. Find more information in the comments",
        },
      }
    },
  },
}
