return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        toml = { "topiary" },
        python = { "black" },
        csharp = { "csharpier" },
        json = { "prettier" },
      },
      formatters = {
        topiary = {
          command = "topiary",
          args = { "format", "--language", "toml" },
        },
      },
    },
    event = "LazyFile",
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format { async = true }
        end,
      },
    },
  },
  {
    "hedyhli/outline.nvim",
    keys = {
      { "<leader>oo", "<cmd>Outline<cr>", desc = "Toggle Outline" },
    },
    cmd = {
      "Outline",
    },
    opts = {
      providers = {
        priority = {
          "lsp",
          "markdown",
          "treesitter",
        },
      },
    },
    dependencies = {
      "epheien/outline-treesitter-provider.nvim",
    },
  },
  {
    "stevearc/aerial.nvim",
    opts = {},
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = { "AerialNavToggle" },
  },
  {
    "folke/trouble.nvim",
    opts = {},
    cmd = { "Trouble" },
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle fitler.buf=0<cr>",
        desc = "Document Diagnostics",
      },
      {
        "<leader>xl",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List",
      },
      {
        "<leader>xq",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List",
      },
    },
  },
}
