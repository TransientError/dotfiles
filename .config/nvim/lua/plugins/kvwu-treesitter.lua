return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "VeryLazy", "BufReadPost", "BufWritePost", "BufNewFile" },
  },
}
