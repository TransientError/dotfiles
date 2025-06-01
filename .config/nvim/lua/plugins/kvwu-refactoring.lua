local utils = require "utils"
if utils.minimal() then
  return {}
end

return {
  "ThePrimeagen/refactoring.nvim",
  opts = { show_success_message = true },
  event = { "BufReadPre", "BufNewFile" },
  cmd = "Refactor",
  keys = function()
    local refactoring = require "refactoring"
    return {
      { "<leader>r", "", desc = "+refactor", mode = { "n", "v" } },
      {
        "<leader>rs",
        function()
          require("telescope").extensions.refactoring.refactors()
        end,
        mode = "v",
        desc = "Refactor",
      },
      {
        "<leader>ri",
        function()
          return refactoring.refactor "Inline Variable"
        end,
        mode = { "n", "v" },
        desc = "Inline Variable",
        expr = true
      },
      {
        "<leader>rf",
        function()
          return refactoring.refactor "Extract Function"
        end,
        mode = "v",
        desc = "Extract Function",
        expr = true
      },
      {
        "<leader>rx",
        function()
          return refactoring.refactor "Extract Variable"
        end,
        mode = "v",
        desc = "Extract Variable",
        expr = true
      },
      {
        "<leader>rp",
        function()
          refactoring.debug.printf { below = false }
        end,
        desc = "printf"
      },
      {
        "<leader>rv",
        function()
          refactoring.debug.print_var {}
        end,
        mode = { "n", "x" },
        desc = "print variable"
      },
      {
        "<leader>rc",
        function()
          refactoring.debug.cleanup {}
        end,
        desc = "Cleanup print statements"
      },
    }
  end,
  config = function(_, opts)
    require("refactoring").setup(opts)
    require("telescope").load_extension "refactoring"
  end,
}
