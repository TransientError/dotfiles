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

            vim.keymap.set("n", "gD", omnisharp_extended.lsp_type_definition, bufopts)
            vim.keymap.set("n", "gd", omnisharp_extended.lsp_definition, bufopts)
            vim.keymap.set("n", "gu", omnisharp_extended.telescope_lsp_references, bufopts)
            vim.keymap.set("n", "gi", omnisharp_extended.lsp_implementation, bufopts)
          else
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
            vim.keymap.set("n", "gd", builtin.lsp_definitions, bufopts)
            vim.keymap.set("n", "gu", builtin.lsp_references, bufopts)
            vim.keymap.set("n", "gi", builtin.lsp_implementations, bufopts)
          end

          vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
          vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
          vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
          vim.keymap.set("n", "<space>cr", vim.lsp.buf.rename, bufopts)
          vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)

          vim.keymap.set("n", "<leader>si", builtin.lsp_document_symbols, bufopts)
          vim.keymap.set("n", "<leader>sI", builtin.lsp_workspace_symbols, bufopts)
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
        enable_roslyn_analyzers = true,
        organize_imports_on_format = true,
        enable_import_completion = true,
        analyze_open_documents_only = true,
      })

      vim.lsp.enable { "lua_ls", "ts_ls", "pyright", "yamlls" }
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    config = function()
      local cmp = require "cmp"
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
          ["<CR>"] = cmp.mapping.confirm { select = true },
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "s" }),
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

      cmp.setup.cmdline({ "/", "?" }, { mapping = cmp.mapping.preset.cmdline(), sources = { { name = "buffer" } } })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
      })

      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      vim.lsp.config("*", {
        capabilities = capabilities,
      })
    end,
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp", module = "cmp_nvim_lsp" },
      { "hrsh7th/cmp-path", lazy = true },
      { "hrsh7th/cmp-cmdline", lazy = true },
      { "ray-x/cmp-treesitter", lazy = true },
      { "hrsh7th/cmp-buffer", lazy = true },
      { "hrsh7th/cmp-vsnip", lazy = true },
      { "hrsh7th/vim-vsnip", lazy = true },
      { "Hoffs/omnisharp-extended-lsp.nvim", module = "omnisharp_extended" },
    },
  },
}
