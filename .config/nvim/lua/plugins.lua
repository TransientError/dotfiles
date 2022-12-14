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
  require('kvwu-lsp').setup(use)
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
  use "Pocco81/auto-save.nvim"
  require('kvwu-theme').setup(use, not_vscode)
  require('kvwu-debuggers').setup(use, not_vscode)
  require('kvwu-telescope').setup(use, not_vscode)
  require('kvwu-treesitter').setup(use, not_vscode)
  require('kvwu-navigation').setup(use, not_vscode)
  require('kvwu-python').setup(use, not_vscode)
  require('kvwu-misc-old-crap').setup(use, not_vscode)
  require('kvwu-version-control').setup(use, not_vscode)
end)
