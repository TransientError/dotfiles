return {
  {
    "echasnovski/mini.surround",
    version = false,
    opts = {
      mappings = {
        add = "ys",
        delete = "ds",
        replace = "cs",
      },
    },
    keys = {
      { "ys", "", desc = "add surround" },
      { "ds", "", desc = "delete surround" },
      { "cs", "", desc = "replace surround" },
      {
        "S",
        function()
          require("mini.surround").add "visual"
        end,
        mode = { "v" },
        silent = true,
      },
    },
    config = function(_, opts)
      require("mini.surround").setup(opts)
      vim.keymap.del("x", "ys")
    end,
  },
  {
    "windwp/nvim-autopairs",
    config = function()
      local npairs = require "nvim-autopairs"
      npairs.setup {}
      local Rule = require "nvim-autopairs.rule"
      npairs.add_rule(Rule("`", "`", "-ocaml"))
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = { formatters_by_ft = { lua = { "stylua" } } },
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
    "wellle/targets.vim",
    event = "LazyFile",
    init = function()
      vim.cmd [[
        autocmd User targets#mappings#user call targets#mappings#extend({
           \ 'a': {'argument': [{'o':'[({<[]', 'c':'[]}>)]', 's': ','}]}
           \ })
     ]]
    end,
  },
  {
    "gbprod/substitute.nvim",
    opts = {},
    keys = {
      {
        "gr",
        function()
          require("substitute").operator()
        end,
        mode = "n",
        noremap = true,
      },
    },
  },
  {
    "aaronik/treewalker.nvim",
    opts = {},
    keys = {
      {
        "<leader>sl",
        "<cmd>Treewalker SwapRight<cr>",
        silent = true,
      },
      {
        "<leader>sh",
        "<cmd>Treewalker SwapLeft<cr>",
        silent = true,
      },
      {
        "<leader>sj",
        "<cmd>Treewalker SwapDown<cr>",
        silent = true,
      },
      {
        "<leader>sk",
        "<cmd>Treewalker SwapUp<cr>",
        silent = true,
      },
    },
  },
}
