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
  },
  {
    "lambdalisue/suda.vim",
    cmd = { "SudaWrite" },
  },
  "vim-scripts/ReplaceWithRegister",
  {
    "ggandor/leap.nvim",
    keys = {
      { "s", "<Plug>(leap-forward)", mode = { "n", "v" } },
      { "S", "<Plug>(leap-backward)", mode = { "n" } },
      { "gs", "<Plug>(leap-from-window)", mode = { "n", "v" } },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {},
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
    "chentoast/marks.nvim",
    opts = {},
  },
  {
    "pocco81/auto-save.nvim",
    event = "LazyFile",
    opts = {
      condition = function(buf)
        local path = vim.fn.expand "%:p"
        local config = vim.fn.stdpath "config"
        return vim.fn.getbufvar(buf, "&modifiable") == 1 and not string.find(path, "^" .. config)
      end,
    },
  },
  {
    "akinsho/toggleterm.nvim",
    keys = {
      { "<leader>ot", ":ToggleTerm<CR>" },
    },
    opts = {
      -- this is buggy for me
      shade_terminals = false,
      hide_numbers = false,
    },
  },
  {
    "airblade/vim-rooter",
    init = function()
      vim.g.rooter_patterns = { ".git", "=nvim" }
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = "LazyFile",
  },
  {
    "github/copilot.vim",
    event = { "LazyFile", "VeryLazy" },
    config = function()
      vim.keymap.set("i", "<right>", 'copilot#Accept("\\<right>")', { expr = true, replace_keycodes = false })
    end,
  },
  {
    "rafamadriz/friendly-snippets",
    event = "VeryLazy",
  },
  {
    "kmonad/kmonad-vim",
    ft = "kbd",
  },
  { "eraserhd/parinfer-rust", build = "cargo build --release", ft = "lisp" },
  { "b0o/SchemaStore", ft = { "json", "jsonc", "yaml" } },
  { "williamboman/mason.nvim", opts = {}, event = "VeryLazy" },
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
}
