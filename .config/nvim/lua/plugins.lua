local function not_vscode()
  return vim.fn.exists "g:vscode" == 0
end

return require("packer").startup(function(use)
  use "wbthomason/packer.nvim"
  use {
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
    cond = not_vscode,
  }
  use "tpope/vim-surround"
  use "lambdalisue/suda.vim"
  use "tpope/vim-commentary"
  use "vim-scripts/ReplaceWithRegister"
  use {
    "wellle/targets.vim",
    config = function()
      vim.cmd [[
         autocmd User targets#mappings#user call targets#mappings#extend({
            \ 'a': {'argument': [{'o':'[({<[]', 'c':'[]}>)]', 's': ','}]}
            \ })
      ]]
    end,
  }
  use "ggandor/lightspeed.nvim"
  use {
    "folke/which-key.nvim",
    cond = function()
      return vim.fn.exists "g:vscode" == 0
    end,
    config = function()
      require("which-key").setup()
    end,
  }
  require("kvwu-lsp").setup(use)
  use {
    "windwp/nvim-autopairs",
    config = function()
      local npairs = require "nvim-autopairs"
      npairs.setup {}

      local Rule = require "nvim-autopairs.rule"
      npairs.add_rule(Rule("`", "`", "-ocaml"))
    end,
  }
  use {
    "chentoast/marks.nvim",
    config = function()
      require("marks").setup {}
    end,
  }
  use "Pocco81/auto-save.nvim"
  require("kvwu-theme").setup(use, not_vscode)
  require("kvwu-debuggers").setup(use, not_vscode)
  require("kvwu-telescope").setup(use, not_vscode)
  require("kvwu-treesitter").setup(use, not_vscode)
  require("kvwu-navigation").setup(use, not_vscode)
  require("kvwu-python").setup(use, not_vscode)
  require("kvwu-misc-old-crap").setup(use, not_vscode)
  require("kvwu-version-control").setup(use, not_vscode)
  use {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup {
        -- this is buggy for me
        shade_terminals = false,
        hide_numbers = false,
      }
      vim.keymap.set("", "<leader>ot", ":ToggleTerm<CR>")
    end,
  }
  use {
    "airblade/vim-rooter",
    config = function()
      vim.g.rooter_patterns = { ".git", "=nvim" }
    end,
  }
  use {
    "alvan/vim-closetag",
    config = function()
      vim.g.closetag_filenames = "*.html,*.xml,*.tsx,*.csproj,*.vue,*.svelte"
      vim.g.closetag_filetypes = "vue,html,htmldjango,svelte"
    end,
  }
  use "AndrewRadev/tagalong.vim"
  use "github/copilot.vim"
end)
