local obsidian_vault_path = "~/Documents/stuff"
local utils = require("utils")
if utils.minimal() or not utils.profiles_contain("notes") then
  return {}
end

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
  -- {
  --   "MeanderingProgrammer/render-markdown.nvim",
  --   dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" }, -- if you prefer nvim-web-devicons
  --   ---@module 'render-markdown'
  --   ---@type render.md.UserConfig
  --   opts = {
  --     completions = {
  --       lsp = {
  --         enabled = true,
  --       },
  --     },
  --   },
  --   ft = "markdown",
  --   cmd = {
  --     "RenderMarkdown",
  --   },
  --   keys = {
  --     {
  --       "<localleader>r",
  --       function()
  --         require("render-markdown").buf_toggle()
  --       end,
  --       desc = "Render Markdown",
  --     },
  --   },
  -- },
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    event = {
      "BufReadPre " .. obsidian_vault_path .. "/**/*.md",
      "BufNewFile " .. obsidian_vault_path .. "/**/*.md",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = {
      "ObsidianOpen",
      "ObsidianSearch",
      "ObsidianToday",
      "ObsidianBacklinks",
      "ObsidianQuickSwitch",
      "ObsidianNew",
    },
    keys = {
      {
        "<leader>nrf", "<cmd>ObsidianQuickSwitch<cr>",
      },
      {
        "<leader>nrn", "<cmd>ObsidianNew<cr>",
      },
      {
        "<leader>nrs", "<cmd>ObsidianSearch<cr>",
      },
    },
    opts = {
      workspaces = {
        {
          name = "stuff",
          path = obsidian_vault_path,
        }
      },
      ui = {
        enable = false,
      },
      follow_url_func = function(url)
        if url:match("^obsidian://") then
          local path = url:gsub("^obsidian://", "")
          vim.cmd("ObsidianOpen " .. path)
        else
          vim.fn.system("xdg-open " .. url)
        end
      end,
      note_id_func = function(title)
        -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
        -- In this case a note with the title 'My new note' will be given an ID that looks
        -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
        local suffix = ""
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          -- If title is nil, just add 4 random uppercase letters to the suffix.
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.time()) .. "-" .. suffix
      end,
    }
  },
  {
    "chipsenkbeil/org-roam.nvim",
    tag = "0.1.1",
    dependencies = {
      "nvim-orgmode/orgmode",
    },
    opts = {
      directory = "~/Documents/org/org-roam",
      bindings = {
        capture = "<leader>Xc",
        find_node = "<leader>nrf",
      }
    }
  }
}
