if require("utils").minimal() then
  return {}
end

return {
  {
    "lambdalisue/suda.vim",
    cmd = { "SudaWrite" },
  },
  {
    "folke/which-key.nvim",
    opts = {},
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
        local configs = { vim.env.HOME .. "/.config/wezterm" }
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
      vim.g.rooter_patterns = { ".git", "=nvim", "=fish", "^.config", "^explore" }
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = "LazyFile",
  },
  {
    "kmonad/kmonad-vim",
    ft = "kbd",
  },
  { "eraserhd/parinfer-rust", build = "cargo build --release", ft = "lisp" },
  { "b0o/SchemaStore", ft = { "json", "jsonc", "yaml" } },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>m", "<cmd>Mason<CR>" } },
    opts = {},
    event = "VeryLazy",
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {},
  },
  {
    "folke/snacks.nvim",
    lazy = false,
    opts = {
      bigfile = {},
      lazygit = {},
    },
    keys = {
      {
        "<leader>gg",
        function()
          require("snacks").lazygit()
        end,
      },
    },
  },
}
