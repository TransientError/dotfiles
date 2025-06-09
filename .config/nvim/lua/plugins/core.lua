local surround_prefix = "gj"
local add = surround_prefix .. "a"
local delete = surround_prefix .. "d"
local change = surround_prefix .. "c"

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
      { add, desc = "add surround", mode = { "n", "x", "o" } },
      { delete, desc = "delete surround", mode = { "n", "x", "o" } },
      { change, desc = "replace surround", mode = { "n", "x", "o" } },
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
    event = "InsertEnter",
    config = function()
      local npairs = require "nvim-autopairs"
      npairs.setup {
        check_ts = true,
      }
      local Rule = require "nvim-autopairs.rule"
      npairs.add_rule(Rule("`", "`", "-ocaml"))
    end,
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
    "echasnovski/mini.operators",
    version = "*",
    opts = {
      sort = {
        prefix = "",
      },
      multiply = {
        prefix = "",
      },
    },
    keys = {
      { "g=", modes = { "n", "x", "o" }, desc = "evaluate" },
      { "gr", modes = { "n", "x", "o" }, desc = "replace" },
      { "gx", modes = { "n", "x", "o" }, desc = "exchange" },
    },
    event = "VeryLazy",
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
  },
  {
    "ggandor/leap.nvim",
    lazy = false,
    config = function()
      vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")
      vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-from-window)")
      vim.keymap.set({ "n", "x", "o" }, "gs", function()
        require("leap.remote").action()
      end)
      vim.keymap.set({ "n", "x", "o" }, "R", function()
        require("leap.treesitter").select()
      end)
      vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })
    end,
  },
  { "echasnovski/mini.splitjoin", version = "*", opts = {}, event = "VeryLazy" },
}
