local utils = require "utils"
if utils.minimal() then
  return {}
end

return {
  {
    "nvim-tree/nvim-tree.lua",
    enabled = false,
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
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      "s1n7ax/nvim-window-picker",
    },
    lazy = false,
    opts = {
      filesystem = {
        bind_to_cwd = true,
        window = {
          mappings = {
            ["l"] = "set_root",
            ["/"] = "noop",
            ["v"] = "open_vsplit",
          },
        },
      },
      window = {
        mappings = {
          ["s"] = {
            function(state)
              utils.flash_jump()
            end,
          },
        },
      },
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)
      vim.keymap.set("n", "<leader>op", "<cmd>Neotree toggle<CR>", { desc = "Neotree: Toggle" })
    end,
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
    "mikavilpas/yazi.nvim",
    cond = function()
      return vim.g.neovide
    end,
    event = "VeryLazy",
    cmd = "Yazi",
    keys = {
      { "<leader>y", "<cmd>Yazi<CR>", mode = { "n" } },
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
