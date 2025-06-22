local utils = require "utils"
if utils.minimal() then
  return {}
end

return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    opts = function()
      local gs = require "gitsigns"
      return {
        on_attach = function(bufnr)
          local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
          end

          map("n", "]c", function()
            if vim.wo.diff then
              vim.cmd.normal { "]c", bang = true }
            else
              gs.nav_hunk "next"
            end
          end, "Next Hunk")
          map("n", "[c", function()
            if vim.wo.diff then
              vim.cmd.normal { "[c", bang = true }
            else
              gs.nav_hunk "prev"
            end
          end, "Previous Hunk")
          map({ "n", "v" }, "<localleader>ghs", gs.stage_hunk, "Stage Hunk")
          map("n", "<localleader>gs", gs.stage_buffer, "Stage buffer")
          map({ "n", "v" }, "<localleader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
          map({ "n", "v" }, "<localleader>ghr", gs.reset_hunk, "Reset Hunk")
          map("n", "<localleader>gr", gs.reset_buffer, "Reset Buffer")
        end,
      }
    end,
    dependencies = {
      "tpope/vim-repeat",
    },
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = "Neogit",
    keys = {
      {
        "<leader>gg",
        "<cmd>Neogit<cr>",
        silent = true,
      },
    },
    opts = function()
      local colors = require "material.colors"
      return {
        highlight = {
          bg_green = colors.editor.bg,
          bg_red = colors.editor.bg,
          line_green = colors.editor.bg,
          line_red = colors.editor.bg,
        },
      }
    end,
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFileHistory" },
    opts = function()
      return {
        keymaps = {
          file_panel = {
            ["S"] = false,
            { "n", "<leader>gd", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
            { "n", "<leader>wd", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
            { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
            { "n", "c", "<cmd>Git commit<cr>", { desc = "Commit changes" } },
            { "n", "p", "<cmd>Git pull<cr>", { desc = "pull changes" } },
            { "n", "P", "<cmd>Git push<cr>", { desc = "push changes" } },
          },
          view = {
            { "n", "<leader>gd", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
            { "n", "<leader>wd", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
          },
          file_history_panel = {
            { "n", "<leader>gd", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
            { "n", "<leader>wd", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
            { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
          },
        },
      }
    end,
    keys = {
      {
        "<leader>gd",
        "<cmd>DiffviewOpen<cr>",
        desc = "Open Diffview",
      },
    },
  },
  {
    "tpope/vim-fugitive",
    cmd = { "Git" },
    keys = {
      {
        "<leader>gC",
        "<cmd>Git commit<cr>",
        silent = true,
        desc = "git commit",
      },
      {
        "<leader>gp",
        "<cmd>Git pull<cr>",
        silent = true,
        desc = "git pull",
      },
      {
        "<leader>gP",
        "<cmd>Git push<cr>",
        silent = true,
        desc = "git push",
      },
      {
        "<leader>gs",
        "<cmd>Git switch -c ",
        silent = true,
        desc = "git new branch",
      },
    }
  },
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    opts = {
      default_mappings = false,
    },
    dependencies = {
      "nvimtools/hydra.nvim",
    },
    config = function(_, opts)
      require("git-conflict").setup(opts)
      local Hydra = require "hydra"
      Hydra {
        name = "Git Conflict",
        color = "amaranth",
        mode = { "n" },
        body = "<leader>gc",
        heads = {
          { "h", "<Plug>(git-conflict-ours)", { desc = "Use ours" } },
          { "l", "<Plug>(git-conflict-theirs)", { desc = "Use theirs" } },
          { "b", "<Plug>(git-conflict-both)", { desc = "Use both" } },
          { "0", "<Plug>(git-conflict-none)", { desc = "Use neither" } },
          { "p", "<Plug>(git-conflict-prev-conflict)", { desc = "Previous conflict" } },
          { "n", "<Plug>(git-conflict-next-conflict)", { desc = "Next conflict" } },
          { "r", "<Plug>(git-conflict-reset)", { desc = "Reset conflict" } },
          { "<Esc>", nil, { exit = true, nowait = true } },
        },
      }
    end,
  },
}
