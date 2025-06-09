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
}
