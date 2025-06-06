local utils = require "utils"

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
      { add, desc = "add surround", mode = { "n", "x" } },
      { delete, desc = "delete surround" },
      { change, desc = "replace surround" },
      {
        "S",
        ":<C-u>lua require('mini.surround').add 'visual'<CR>",
        mode = "x",
        silent = true,
      },
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
    opts = {
      modes = {
        search = {
          enabled = true,
        },
      },
    },
    keys = {
      -- {
      --   "s",
      --   function()
      --     utils.flash_jump()
      --   end,
      --   mode = { "n", "x", "o" },
      --   desc = "Flash",
      -- },
      -- {
      --   "S",
      --   function()
      --     require("flash").treesitter()
      --   end,
      --   mode = { "n", "x", "o" },
      --   desc = "Flash Treesitter",
      -- },
      -- {
      --   "r",
      --   function()
      --     require("flash").remote()
      --   end,
      --   mode = { "o", "x" },
      --   desc = "Flash Remote",
      -- },
      -- {
      --   "R",
      --   function()
      --     require("flash").treesitter_search()
      --   end,
      --   mode = { "o", "x" },
      --   desc = "Flash Treesitter Search",
      -- },
    },
  },
  {
    "ggandor/leap.nvim",
    lazy = false,
    config = function()
      vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")
      vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-from-window)")
      vim.keymap.set({ "x", "o" }, "r", function()
        require("leap.remote").action()
      end)
      vim.keymap.set({ "n", "x", "o" }, "R", function()
        require("leap.treesitter").select()
      end)
    end,
  },
}
