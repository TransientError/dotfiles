return {
  {
    "dhruvasagar/vim-table-mode",
    ft = "markdown",
    cmd = {
      "TableModeToggle",
      "TableModeRealign",
      "Tableize",
    },
    init = function ()
      vim.g.table_mode_map_prefix = "<localleader>t"
    end
  }
}
