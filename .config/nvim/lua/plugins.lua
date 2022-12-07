return require("packer").startup(function(use)
  use {
    "kaicataldo/material.vim",
    config = function()
      vim.g.material_theme_style = "dark"
      vim.cmd "colorscheme material"
      vim.opt.background = "dark"
      if vim.fn.has "termguicolors" == 1 then
        vim.opt.termguicolors = true
      end
    end,
  }
  use {
    "sbdchd/neoformat",
    config = function()
      vim.keymap.set("", "<leader>cf", ":Neoformat<CR>")
    end,
  }
  use "tpope/vim-surround"
  use {
    "itchyny/lightline.vim",
    config = function()
      vim.g.lightline = { colorscheme = "material_vim" }
    end,
  }
  use "lambdalisue/suda.vim"
  use {
    "airblade/vim-gitgutter",
    cond = function()
      return vim.fn.glob ".git" ~= nil
    end,
  }
  use {
    "alvan/vim-closetag",
    config = function()
      vim.g.closetag_filenames = "*.html,*.xml,*.plist,*.*proj"
    end,
    ft = { "html", "xml" },
  }
  use "tpope/vim-commentary"
  use { "dag/vim-fish", ft = "fish" }
  use { "mattn/emmet-vim", ft = { "html", "jsx" } }
  use { "cespare/vim-toml", ft = "toml" }
  use "vim-scripts/ReplaceWithRegister"
  use { "jparise/vim-graphql", ft = "graphql" }
  use "wellle/targets.vim"
  use "ggandor/lightspeed.nvim"
  use "michaeljsmith/vim-indent-object"
  use {
    "folke/which-key.nvim",
    cond = function()
      return vim.fn.exists "g:vscode" == 0
    end,
    config = function()
      require("which-key").setup {}
    end,
  }
  use {
    "nvim-tree/nvim-tree.lua",
    cond = function()
      return vim.fn.exists "g:vscode" == 0
    end,
    config = function()
      require("nvim-tree").setup {
        update_focused_file = {
          enable = true,
        },
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        view = {
          mappings = {
            custom_only = false,
            list = {
              { key = "l", action = "cd" },
            },
          },
        },
      }
      vim.keymap.set({ "n", "v" }, "<leader>op", ":NvimTreeToggle<CR>")
    end,
    cmd = { "NvimTreeToggle" },
    keys = "<leader>op",
  }
  use {
    "hrsh7th/nvim-cmp",
    opt = true,
    cond = function()
      return vim.fn.exists "g:vscode" == 0
    end,
    config = function()
      require("kvwu-cmp").setup()
    end,
    requires = {
      { "hrsh7th/cmp-path", opt = true },
      { "hrsh7th/cmp-cmdline", opt = true },
      { "ray-x/cmp-treesitter", opt = true },
      { "hrsh7th/cmp-buffer", opt = true },
      { "hrsh7th/cmp-vsnip", opt = true },
      { "hrsh7th/vim-vsnip", opt = true },
      { "hrsh7th/cmp-nvim-lsp", module = "cmp_nvim_lsp" },
      { "neovim/nvim-lspconfig", module = "lspconfig" },
    },
  }
  use {
    "tpope/vim-fugitive",
    cond = function()
      return vim.fn.exists "g:vscode" == 0 and vim.fn.glob ".git" ~= nil
    end,
    config = function()
      vim.keymap.set("n", "<leader>gg", ":Git<CR>")
    end,
  }
  use {
    "nvim-telescope/telescope.nvim",
    cond = function()
      return vim.fn.exists "g:vscode" == 0
    end,
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    config = function()
      local builtin = require "telescope.builtin"
      vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
      vim.keymap.set("n", "<leader>/", builtin.live_grep, {})
      vim.keymap.set("n", "<leader>,", builtin.buffers, {})
      vim.keymap.set("n", "<leader>ha", builtin.help_tags, {})
    end,
  }
  use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
  use {
    "p00f/nvim-ts-rainbow",
    after = { "nvim-treesitter" },
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = { "python" },
        highlight = {
          enable = true,
        },
        rainbow = {
          enable = true,
          colors = { "#fac15e", "#9b64d0", "#406cf1" },
        },
      }
    end,
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
  use {
    "luochen1990/rainbow",
    config = function()
      vim.g.rainbow_active = 1
      vim.g.rainbow_conf = {
        guifgs = { "#fac15e", "#9b64d0", "#406cf1" },
      }
    end,
  }
  use {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup {}
    end,
  }
  use {
    "chentoast/marks.nvim",
    config = function()
      require("marks").setup {}
    end,
  }
  use {
    "petobens/poet-v",
    cond = function()
      return vim.fn.exists "g:vscode" == 0
    end,
    ft = "python",
    setup = function()
      vim.g.poetv_executables = { "poetry" }
    end,
  }
  use {
    "nvim-telescope/telescope-project.nvim",
    cond = function()
      return vim.fn.exists "g:vscode" == 0
    end,
    config = function()
      local telescope = require "telescope"
      telescope.load_extension "project"
      vim.keymap.set("n", "<leader>pp", telescope.extensions.project.project)
    end,
    requires = { "nvim-telescope/telescope.nvim", module = "telescope" },
  }
  use {
    "mfussenegger/nvim-dap",
    cond = function ()
      return vim.fn.exists "g:vscode" == 0
    end,
    config = function()
      require('kvwu-nvim-dap').setup()
    end,
    requires = { "anuvyklack/hydra.nvim" },
  }
  use {
    "mxsdev/nvim-dap-vscode-js",
    cond = function()
      return vim.fn.exists "g:vscode" == 0
    end,
    requires = {
      "mfussenegger/nvim-dap",
      { "microsoft/vscode-js-debug", opt = true, run = "npm install --legacy-peer-deps && npm run compile" },
    },
    ft = "typescript",
    config = function()
      require("dap-vscode-js").setup {
        adapters = { "pwa-node" },
      }

      require("dap").configurations["typescript"] = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          runtimeArgs = { "--nolazy", "-r", "ts-node/register", "--loader", "ts-node/esm.mjs" },
          cwd = "${fileDirname}",
          args = "${file}",
          sourceMaps = true,
        },
      }
    end,
  }
  use {
    "rcarriga/nvim-dap-ui",
    cond = function()
      return vim.fn.exists "g:vscode" == 0
    end,
    requires = { "mfussenegger/nvim-dap" },
    config = function()
      require('kvwu-dap-ui').setup()
    end,
  }
end)
