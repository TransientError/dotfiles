if require("utils").minimal() then
  return {}
end

return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      vim.opt.completeopt = { "menuone", "noselect", "menu" }
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client == nil then
            error("client was nil", 1)
            return
          end

          local bufopts = { noremap = true, silent = true, buffer = ev.buf }

          local builtin = require "telescope.builtin"
          if client.name == "omnisharp" then
            local omnisharp_extended = require "omnisharp_extended"

            vim.keymap.set("n", "gD", omnisharp_extended.telescope_lsp_type_definition, bufopts)
            vim.keymap.set("n", "gd", omnisharp_extended.telescope_lsp_definitions, bufopts)
            vim.keymap.set("n", "gu", omnisharp_extended.telescope_lsp_references, bufopts)
            vim.keymap.set("n", "gi", omnisharp_extended.telescope_lsp_implementation, bufopts)
          else
            vim.keymap.set("n", "gD", builtin.lsp_type_definitions, bufopts)
            vim.keymap.set("n", "gd", builtin.lsp_definitions, bufopts)
            vim.keymap.set("n", "gu", builtin.lsp_references, bufopts)
            vim.keymap.set("n", "gi", builtin.lsp_implementations, bufopts)
          end

          vim.keymap.set("n", "K", require("lsp_signature").toggle_float_win, bufopts)
          vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
          vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
          vim.keymap.set("n", "<space>cr", vim.lsp.buf.rename, bufopts)
          vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)

          vim.keymap.set("n", "<leader>si", builtin.lsp_document_symbols, bufopts)
          vim.keymap.set("n", "<leader>sI", builtin.lsp_workspace_symbols, bufopts)

          if client.name == "jsonls" or client.name == "yamlls" then
            require("nvim-navic").attach(client, ev.buf)
          end
        end,
      })

      vim.keymap.set("n", "<C-k>", vim.diagnostic.open_float)

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
              path = {
                "lua/?.lua",
                "lua/?/init.lua",
              },
            },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.api.nvim_get_runtime_file("", true),
              },
            },
            diagnostics = { globals = { "vim" } },
            telemetry = { enable = false },
          },
        },
      })

      local json_capabilities = vim.lsp.protocol.make_client_capabilities()
      json_capabilities.textDocument.completion.completionItem.snippetSupport = true
      vim.lsp.config("jsonls", {
        capabilities = json_capabilities,
      })

      vim.lsp.config("omnisharp", {
        cmd = { "omnisharp", "-z", "--languageserver" },
        settings = {
          RoslynExtensionsOptions = {
            EnableAnalyzersSupport = true,
            EnableImportCompletion = true,
            AnalyzeOpenDocumentsOnly = true,
            EnableDecompilationSupport = true,
          },
        }
      })

      vim.lsp.enable { "lua_ls", "ts_ls", "pyright", "yamlls", "omnisharp" }
    end,
    dependencies = {
      { "SmiteshP/nvim-navic", lazy = true },
      { "ray-x/lsp_signature.nvim", lazy = true },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    config = function()
      local cmp = require "cmp"
      local confirm_or_fallback = function(fallback)
        if cmp.visible() and cmp.get_active_entry() then
          cmp.confirm { select = false, behavior = cmp.ConfirmBehavior.Replace }
        else
          fallback()
        end
      end
      cmp.setup {
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        window = {
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert {
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping {
            i = confirm_or_fallback,
            s = cmp.mapping.confirm { select = true },
            c = cmp.mapping.confirm { select = false, behavior = cmp.ConfirmBehavior.Replace },
          },
          ["<C-CR>"] = cmp.mapping(function(_)
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "i", true)
          end, { "i" }),
          ["<Tab>"] = cmp.mapping(confirm_or_fallback, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = cmp.config.sources {
          { name = "nvim_lsp" },
          { name = "vsnip" },
        },
        {
          { name = "buffer" },
        },
      }

      cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources {
          { name = "cmp_git" },
        },
        {
          { name = "buffer" },
        },
      })

      cmp.setup.filetype("markdown", {
        sources = cmp.config.sources {
          { name = "render-markdown" },
          { name = "vsnip" },
        },
        {
          { name = "buffer" },
        },
      })

      cmp.setup.cmdline({ "/", "?" }, { mapping = cmp.mapping.preset.cmdline(), sources = { { name = "buffer" } } })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
      })

      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      local cmp_autopairs = require "nvim-autopairs.completion.cmp"
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp", lazy = true },
      { "hrsh7th/cmp-path", lazy = true },
      { "hrsh7th/cmp-cmdline", lazy = true },
      { "ray-x/cmp-treesitter", lazy = true },
      { "hrsh7th/cmp-buffer", lazy = true },
      { "hrsh7th/cmp-vsnip", lazy = true },
      { "hrsh7th/vim-vsnip", lazy = true },
      { "Hoffs/omnisharp-extended-lsp.nvim", lazy = true },
      { "windwp/nvim-autopairs", lazy = true },
    },
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "InsertEnter",
    opts = {
      auto_close_after = nil,
    },
  },
  {
    "hrsh7th/vim-vsnip",
    event = "InsertEnter",
    config = function()
      vim.keymap.set("i", "<Tab>", function()
        if vim.fn["vsnip#available"](1) == 1 then
          return "<Plug>(vsnip-expand-or-jump)"
        else
          return "<Tab>"
        end
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<S-Tab>", function()
        if vim.fn["vsnip#available"](1) == 1 then
          return "<Plug>(vsnip-expand-or-jump)"
        else
          return "<S-Tab>"
        end
      end, { expr = true, silent = true })
    end,
  },
}
