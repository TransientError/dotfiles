local add = "gsa"
local delete = "gsd"
local change = "gsc"

return {
  {
    "echasnovski/mini.surround",
    version = false,
    opts = {
      mappings = {
        add = add,
        delete = delete,
        replace = change,
      },
    },
    keys = {
      { add, desc = "add surround" },
      { delete, desc = "delete surround" },
      { change, desc = "replace surround" },
    },
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
  {
    "rafamadriz/friendly-snippets",
    event = "VeryLazy",
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "s",
        function()
          require("flash").jump({
            search = {
              ---@type Flash.Pattern.Mode
              mode = function (str)
                -- allow two spaces to target an empty line
                if str == "  " then
                  return "^$"
                end
                return str
              end
            }
          })
        end,
        mode = { "n", "x", "o" },
        desc = "Flash",
      },
      {
        "S",
        function()
          require("flash").treesitter()
        end,
        mode = { "n" },
        desc = "Flash Treesitter",
      },
      {
        "r",
        function()
          require("flash").remote()
        end,
        mode = { "o", "x" },
        desc = "Flash Remote",
      },
      {
        "R",
        function()
          require("flash").treesitter_search()
        end,
        mode = { "o", "x" },
        desc = "Flash Treesitter Search",
      },
    },
  }
}
