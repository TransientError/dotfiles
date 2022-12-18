local kvwu_version_control = {}

function kvwu_version_control.setup(use, not_vscode)
  use {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
    cond = not_vscode,
  }
  use {
    "tpope/vim-fugitive",
    cond = function()
      return vim.fn.exists "g:vscode" == 0 and vim.fn.glob ".git" ~= nil
    end,
    config = function()
      vim.keymap.set("n", "<leader>gg", ":Git<CR>")
    end,
  }
end

return kvwu_version_control