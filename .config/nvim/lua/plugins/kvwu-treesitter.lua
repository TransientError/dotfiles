return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "LazyFile", "VeryLazy" },
    opts = {
      highlight = {
        enable = true,
      },
    },
    main = "nvim-treesitter.configs",
  },
}
