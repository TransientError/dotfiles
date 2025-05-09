local utils = require "utils"

return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    opts = {},
  },
  {
    "tpope/vim-fugitive",
    cond = function()
      return utils.not_vscode() and vim.fn.glob ".git" ~= nil
    end,
    keys = {
      {
        "<leader>gg",
        ":Git<CR>",
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "fugitive",
        callback = function()
          vim.keymap.set("n", "pu", ":Git push<CR", { noremap = true, buffer = true })
        end,
      })
    end,
  },
}
