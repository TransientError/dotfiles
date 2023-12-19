local kvwu_python = {}

function kvwu_python.setup(use, not_vscode)
  use {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("ibl").setup()
      vim.g.indent_blankline_filetype = { "python" }
    end,
    ft = "python",
    cond = not_vscode,
  }
  use "michaeljsmith/vim-indent-object"
end

return kvwu_python
