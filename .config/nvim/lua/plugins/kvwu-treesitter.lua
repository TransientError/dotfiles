return {
  {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    module = { "nvim-treesitter.query", "nvim-treesitter.configs" },
  },
  {
    "p00f/nvim-ts-rainbow",
    config = function()
      local colors = require "material.colors"
      require("nvim-treesitter.configs").setup {
        ensure_installed = { "python", "lua", "typescript" },
        highlight = {
          enable = true,
        },
        rainbow = {
          enable = true,
          colors = {
            colors.main.purple,
            colors.main.yellow,
            colors.main.blue,
            colors.main.cyan,
            colors.main.green,
            colors.main.orange,
            colors.main.red,
          },
        },
      }

      vim.treesitter.language.register("xml", "html")
    end,
  }
}

