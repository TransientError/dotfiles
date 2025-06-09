if require("utils").minimal() then
  return {}
end

return {
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    cmd = { "Copilot" },
    opts = function()
      local prefix = vim.fn.has "mac" and "D" or "C"
      return {
        suggestion = {
          auto_trigger = true,
          keymap = {
            accept = "<right>",
            accept_word = string.format("<%s-right>", prefix),
            accept_line = string.format("<%s-S-right>", prefix),
          },
        },
      }
    end,
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
