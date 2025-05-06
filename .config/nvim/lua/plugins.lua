return {

  {
    "sbdchd/neoformat",
    config = function()
      vim.keymap.set("", "<leader>cf", ":Neoformat<CR>")
      vim.g.neoformat_enabled_cs = { "csharpier" }
      vim.g.neoformat_enabled_python = { "black" }
      vim.g.neoformat_enabled_ocaml = { "ocamlformat" }
      vim.g.neoformat_svelte_prettierv3 = {
        exe = "prettier",
        args = { "--plugin prettier-plugin-svelte" },
        stdin = 1,
        try_node_exe = 1,
      }
      vim.g.neoformat_enabled_svelte = { "prettierv3" }
    end,
  },
  "tpope/vim-surround",
  "lambdalisue/suda.vim",
  "tpope/vim-commentary",
  "vim-scripts/ReplaceWithRegister",
  {
    "wellle/targets.vim",
    init = function()
      vim.cmd [[
         autocmd User targets#mappings#user call targets#mappings#extend({
            \ 'a': {'argument': [{'o':'[({<[]', 'c':'[]}>)]', 's': ','}]}
            \ })
      ]]
    end,
  },
  {
    "ggandor/leap.nvim",
    config = function()
      vim.keymap.set("n", "s", "<Plug>(leap-forward)")
      vim.keymap.set("n", "S", "<Plug>(leap-backward)")
      vim.keymap.set("n", "gs", "<Plug>(leap-from-window)")
    end,
  },
  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup()
    end,
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
    opts = {}
  },
  "Pocco81/auto-save.nvim",
  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup {
        -- this is buggy for me
        shade_terminals = false,
        hide_numbers = false,
      }
      vim.keymap.set("", "<leader>ot", ":ToggleTerm<CR>")
    end,
  },
  {
    "airblade/vim-rooter",
    config = function()
      vim.g.rooter_patterns = { ".git", "=nvim" }
    end,
  },
  {
    "alvan/vim-closetag",
    config = function()
      vim.g.closetag_filenames = "*.html,*.xml,*.tsx,*.csproj,*.vue,*.svelte"
      vim.g.closetag_filetypes = "vue,html,htmldjango,svelte"
    end,
  },
  "AndrewRadev/tagalong.vim",
  {
    "github/copilot.vim",
    config = function()
      vim.keymap.set("i", "<right>", 'copilot#Accept("\\<right>")', { expr = true, replace_keycodes = false })
    end,
  },
  {
  "rafamadriz/friendly-snippets"
  },
  {
  "kmonad/kmonad-vim",
  },
  { "eraserhd/parinfer-rust", build = "cargo build --release" },
  "b0o/SchemaStore",
  {"williamboman/mason.nvim", opts = {}}

}
