local utils = require("utils")
if utils.minimal() then
  return {}
end

return {
  {
    "udalov/kotlin-vim",
    ft = "kotlin",
  },
  { "jparise/vim-graphql", ft = "graphql" },
  { "cespare/vim-toml", ft = "toml" },
  { "dag/vim-fish", ft = "fish" },
  { "mattn/emmet-vim", ft = { "html", "jsx", "xml" }, keys = { "<C-y>" } },
}
