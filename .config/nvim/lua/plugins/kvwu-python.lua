local utils = require "utils"
if utils.minimal() then
  return {}
end

return {
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = {},
    main = "ibl",
    ft = { "python", "yaml" },
  },
  { "michaeljsmith/vim-indent-object", ft = { "python", "yaml" } },
}
