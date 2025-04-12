return {
  {
    "marko-cerovac/material.nvim",
    config = function()
      vim.g.material_style = "darker"
      require("material").setup {
        lualine_style = "default",
        plugins = {
          "dap",
          "nvim-cmp",
          "nvim-tree",
          "telescope",
          "which-key",
          "gitsigns",
        },
        custom_colors = function(colors)
          colors.editor.fg = "#eeffff"
          colors.editor.fg_dark = colors.main.red
          colors.syntax.colors = "#546e7a"
          colors.editor.selection = "#2c2c2c"
          colors.main.red = "#ff5370"
          colors.editor.accent = colors.main.cyan
          colors.syntax.type = colors.main.yellow
        end,
      }
      vim.cmd "colorscheme material"
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      local colors = require "material.colors"
      require("lualine").setup {
        options = {
          theme = {
            normal = {
              a = { fg = colors.editor.bg, bg = colors.main.cyan, gui = "bold" },
              b = { fg = colors.editor.fg, bg = colors.editor.line_numbers },
              c = { fg = colors.editor.fg, bg = colors.editor.selection },
            },
            insert = {
              a = { fg = colors.editor.bg, bg = colors.main.purple, gui = "bold" },
              b = { fb = colors.editor.fg, bg = colors.editor.line_numbers },
            },
            visual = {
              a = { fg = colors.editor.bg, bg = colors.main.blue, gui = "bold" },
              b = { fg = colors.editor.fg, bg = colors.editor.line_numbers },
            },
            replace = {
              a = { fg = colors.editor.bg, bg = colors.main.green, gui = "bold" },
              b = { fg = colors.editor.fg, bg = colors.editor.line_numbers },
            },
            command = {
              a = { fg = colors.editor.bg, bg = colors.main.yellow, gui = "bold" },
              b = { fg = colors.editor.fg, bg = colors.editor.line_numbers },
            },
            inactive = {
              a = { fg = colors.editor.fg, bg = colors.editor.bg, gui = "bold" },
              b = { fg = colors.editor.fg, bg = colors.editor.line_numbers },
              c = { fg = colors.editor.fg, bg = colors.editor.selection },
            },
          },
        },
      }
    end,
  },
  {
    url = "https://gitlab.com/HiPhish/rainbow-delimiters.nvim.git",
    config = function ()
      local colors = require "material.colors"

      vim.api.nvim_set_hl(0, "RainbowDelimiterRed", { fg = colors.main.red })
      vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = colors.main.yellow })
      vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", { fg = colors.main.blue })
      vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", { fg = colors.main.orange })
      vim.api.nvim_set_hl(0, "RainbowDelimiterGreen", { fg = colors.main.green })
      vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { fg = colors.main.purple })
      vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", { fg = colors.main.cyan })

      vim.g.rainbow_delimiters = {
        strategy = {
          [''] = 'rainbow-delimiters.strategy.global',
        },
        query = {
          [''] = 'rainbow-delimiters',
          lua = 'rainbow-blocks',
        },
        priority = {
          [''] = 110,
          lua = 210
        },
      }
    end,
    dependencies = {
      "marko-cerovac/material.nvim"
    }
  }
}

