local utils = require "utils"
if utils.minimal() then
  return {}
end
return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
    },
    keys = {
      {
        "<leader>pf",
        function()
          require("telescope.builtin").find_files { cwd = require("telescope.utils").buffer_dir() }
        end,
      },
      {
        "<leader>fr",
        function()
          require("telescope.builtin").oldfiles()
        end,
      },
      {
        "<leader>,",
        function()
          require("telescope.builtin").buffers()
        end,
      },
      {
        "<leader>ha",
        function()
          require("telescope.builtin").help_tags()
        end,
      },
      "<leader>/",
    },
    config = function()
      local telescope = require "telescope"
      local lga_actions = require "telescope-live-grep-args.actions"

      telescope.load_extension "live_grep_args"
      vim.keymap.set("n", "<leader>/", telescope.extensions.live_grep_args.live_grep_args)

      telescope.setup {
        defaults = {
          mappings = {
            n = {
              ["q"] = require("telescope.actions").close,
            },
          },
        },
        extensions = {
          live_grep_args = {
            auto_quoting = true,
            mappings = {
              i = {
                ["<C-k>"] = lga_actions.quote_prompt(),
              },
            },
          },
        },
      }
    end,
  },
  {
    "nvim-telescope/telescope-project.nvim",
    keys = "<leader>pp",
    config = function()
      local telescope = require "telescope"
      telescope.load_extension "project"
      vim.keymap.set("n", "<leader>pp", telescope.extensions.project.project)
    end,
  },
}
