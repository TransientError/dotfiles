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
    keys = {
      { "ys", "", desc = "add surround" },
      { "ds", "", desc = "delete surround" },
      { "cs", "", desc = "replace surround" },
      {
        "S",
        function()
          require("mini.surround").add "visual"
        end,
        mode = { "v" },
        silent = true,
      },
    },
    config = function(_, opts)
      require("mini.surround").setup(opts)
      vim.keymap.del("x", "ys")
    end,
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
        local file_name = vim.fn.expand "%:t"
        local configs = { vim.fn.stdpath "config", vim.env.USERPROFILE .. "\\.config\\wezterm" }
        local config_files = { ".wezterm.lua" }
        local is_in_config = vim.tbl_contains(configs, function(v)
          return string.find(path, "^" .. v) ~= nil
        end, { predicate = true })
        local is_config_file = vim.list_contains(config_files, file_name)

        return vim.fn.getbufvar(buf, "&modifiable") == 1 and not (is_in_config or is_config_file)
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
}
