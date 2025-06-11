return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = { lua = { "stylua" }, toml = { "topiary" }, python = { "black" } },
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
}
