local kvwu_navigation = {}

function kvwu_navigation.setup(use, not_vscode)
  use {
    "nvim-tree/nvim-tree.lua",
    cond = not_vscode,
    config = function()
      local function on_attach(bufnr)
        local api = require "nvim-tree.api"
        api.config.mappings.default_on_attach(bufnr)

        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        vim.keymap.set("n", "l", api.tree.change_root_to_node, opts "cd")
      end

      require("nvim-tree").setup {
        update_focused_file = {
          enable = true,
        },
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        on_attach = on_attach,
      }
      vim.keymap.set({ "n", "v" }, "<leader>op", ":NvimTreeToggle<CR>")
    end,
    cmd = { "NvimTreeToggle" },
    keys = "<leader>op",
  }
  use {
    "kevinhwang91/rnvimr",
    cond = function()
      return vim.fn.exists "g:neovide" == 1
    end,
    config = function()
      vim.keymap.set("n", "<leader>.", ":RnvimrToggle<CR>")
    end,
  }
end

return kvwu_navigation
