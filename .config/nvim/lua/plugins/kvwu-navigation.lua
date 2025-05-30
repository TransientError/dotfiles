local utils = require "utils"

return {
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      update_focused_file = {
        enable = true,
      },
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      on_attach = function(bufnr)
        local api = require "nvim-tree.api"
        api.config.mappings.default_on_attach(bufnr)

        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        vim.keymap.set("n", "l", api.tree.change_root_to_node, opts "cd")
      end,
    },
    cmd = { "NvimTreeToggle" },
    keys = { { "<leader>op", ":NvimTreeToggle<CR>" } },
  },
  {
    "kevinhwang91/rnvimr",
    cond = utils.neovide,
    keys = {
      {
        "<leader>.",
        ":RnvimrToggle<CR>",
      },
    },
  },
  {
    "brenton-leighton/multiple-cursors.nvim",
    opts = {}, -- This causes the plugin setup function to be called
    keys = {
      { "<C-Up>", "<Cmd>MultipleCursorsAddUp<CR>", mode = { "n", "i", "x" }, desc = "Add cursor and move up" },
      { "<C-Down>", "<Cmd>MultipleCursorsAddDown<CR>", mode = { "n", "i", "x" }, desc = "Add cursor and move down" },

      { "<C-LeftMouse>", "<Cmd>MultipleCursorsMouseAddDelete<CR>", mode = { "n", "i" }, desc = "Add or remove cursor" },

      { "<M-d>", "<Cmd>MultipleCursorsAddJumpNextMatch<CR>", mode = { "n", "x" }, desc = "Jump to next cword" },
    },
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "s",
        function()
          require("flash").jump()
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
  },
  {
    "mikavilpas/yazi.nvim",
    cond = function()
      return vim.g.neovide
    end,
    event = "VeryLazy",
    cmd = "Yazi",
    keys = {
      { "<leader>fe", "<cmd>Yazi<CR>", mode = { "n" } },
    },
    init = function()
      vim.g.loaded_netrwPlugin = 1
    end,
    opts = {
      open_for_directories = true,
      keymaps = {
        show_help = "<f1>",
      },
    },
  },
}
