local kvwu_crap = {}

function kvwu_crap.setup(use, not_vscode)
  use {
    "udalov/kotlin-vim",
    ft = "kotlin",
    cond = not_vscode,
  }
  use { "jparise/vim-graphql", ft = "graphql" }
  use { "cespare/vim-toml", ft = "toml" }
  use { "dag/vim-fish", ft = "fish" }
  use { "mattn/emmet-vim", ft = { "html", "jsx" } }
  use {
    "alvan/vim-closetag",
    config = function()
      vim.g.closetag_filenames = "*.html,*.xml,*.plist,*.*proj"
    end,
    ft = { "html", "xml" },
  }
end

return kvwu_crap
