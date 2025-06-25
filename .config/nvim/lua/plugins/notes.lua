return {
  {
    "dhruvasagar/vim-table-mode",
    ft = "markdown",
    cmd = {
      "TableModeToggle",
      "TableModeRealign",
      "Tableize",
    },
    init = function()
      vim.g.table_mode_map_prefix = "<localleader>t"
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      completions = {
        lsp = {
          enabled = true,
        },
      },
    },
    ft = "markdown",
    cmd = {
      "RenderMarkdown",
    },
    keys = {
      {
        "<localleader>r",
        function()
          require("render-markdown").buf_toggle()
        end,
        desc = "Render Markdown",
      },
    },
  },
}
