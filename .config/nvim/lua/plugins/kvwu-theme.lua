return {
  {
    "marko-cerovac/material.nvim",
    init = function()
      vim.g.material_style = "darker"
      vim.cmd "colorscheme material"
    end,
    lazy = false,
    priority = 1000,
    opts = {
      lualine_style = "default",
      plugins = {
        "dap",
        "nvim-cmp",
        "telescope",
        "which-key",
        "gitsigns",
        "neo-tree",
        "nvim-navic",
        "nvim-web-devicons",
        "trouble",
        "nvim-notify",
        "rainbow-delimiters",
        "indent-blankline",
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
    },
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
        winbar = {
          lualine_c = {
            {
              "navic",
              color_correction = nil,
              navic_opts = nil,
            },
          },
        },
      }
    end,
    dependencies = "mmarko-cerovac/material.nvim",
  },
  {
    url = "https://gitlab.com/HiPhish/rainbow-delimiters.nvim.git",
    init = function()
      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = "rainbow-delimiters.strategy.global",
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
        },
        priority = {
          [""] = 110,
          lua = 210,
        },
      }
    end,
    dependencies = {
      "marko-cerovac/material.nvim",
    },
  },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    opts = function()
      local colors = require "material.colors"
      return {
        options = {
          mode = "tabs",
          right_mouse_command = nil,
          middle_mouse_command = "bdelete! %d",
          always_show_bufferline = false,
        },
        highlights = {
          fill = {
            bg = colors.editor.bg,
          },
        },
      }
    end,
    config = function(_, opts)
      require("bufferline").setup(opts)
      vim.o.showtabline = 1
    end,
  },
}
