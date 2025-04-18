return {
  {
    "hrsh7th/nvim-cmp",
    cond = function()
      return vim.fn.exists "g:vscode" == 0
    end,
    config = function()
      local cmp = require "cmp"

      vim.opt.completeopt = { "menu", "menuone", "noselect" }

      cmp.setup {
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm { select = false },
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
      local lspconfig = require "lspconfig"
      local on_attach = function(client, bufnr)
        print "LSP Attached"
        -- Mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
        -- vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
        vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
        vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set("n", "<space>cr", vim.lsp.buf.rename, bufopts)
        vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
        vim.keymap.set("n", "gu", vim.lsp.buf.references, bufopts)

        local builtin = require "telescope.builtin"
        vim.keymap.set("n", "<space>si", builtin.lsp_document_symbols, bufopts)
        vim.keymap.set("n", "<space>sI", builtin.lsp_workspace_symbols, bufopts)
      end

      vim.keymap.set("n", "<C-k>", vim.diagnostic.open_float)

      lspconfig["lua_ls"].setup {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim", "use", "require" } },
            workspace = { library = vim.api.nvim_get_runtime_file("", true) },
            telemetry = { enable = false },
          },
        },
        capabilities = capabilities,
        on_attach = on_attach,
      }
      lspconfig["omnisharp"].setup {
        cmd = { "dotnet", "/usr/lib/omnisharp/OmniSharp.dll" },
        handlers = { ["textDocument/definition"] = require("omnisharp_extended").handler },
        enable_roslyn_analyzers = true,
        organize_imports_on_format = true,
        enable_import_completion = true,
        analyze_open_documents_only = true,
        capabilities = capabilities,
        on_attach = on_attach,
      }

      require("rust-tools").setup {
        tools = {
          inlay_hints = {
            auto = true,
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = "",
          },
        },
        server = {
          on_attach = on_attach,
          settings = {
            ["rust_analyzer"] = {
              procMacro = {
                enable = true,
              },
              imports = {
                granularity = {
                  group = "module",
                },
                prefix = "self",
              },
            },
          },
        },
      }

      lspconfig["ocamllsp"].setup {
        cmd = { "/home/kvwu/.opam/default/bin/ocamllsp" },
        on_attach = on_attach,
        capabilities = capabilities,
      }

      local json_capabilities = vim.lsp.protocol.make_client_capabilities()
      json_capabilities.textDocument.completion.completionItem.snippetSupport = true

      lspconfig["jsonls"].setup {
        on_attach = on_attach,
        capabilities = json_capabilities,
      }

      lspconfig["volar"].setup {
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "vue" },
      }

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "qf",
        callback = function()
          vim.keymap.set("n", "q", ":close<CR>", { buffer = true, noremap = true })
          vim.keymap.set("n", "<Esc>", ":close<CR>", { buffer = true, noremap = true })
        end,
      })

      for _, server in ipairs {
        "pyright",
        "ts_ls",
        "gopls",
        "kotlin_language_server",
        "hls",
        "julials",
        "cssls",
        "svelte",
        "ccls"
      } do
        lspconfig[server].setup {
          on_attach = on_attach,
          capabilities = capabilities,
        }
      end
    end,
    dependencies = {
      { "hrsh7th/cmp-path", lazy = true },
      { "hrsh7th/cmp-cmdline", lazy = true },
      { "ray-x/cmp-treesitter", lazy = true },
      { "hrsh7th/cmp-buffer", lazy = true },
      { "hrsh7th/cmp-vsnip", lazy = true },
      { "hrsh7th/vim-vsnip", lazy = true },
      { "hrsh7th/cmp-nvim-lsp", lazy = true },
      { "neovim/nvim-lspconfig", lazy = true },
      { "simrat39/rust-tools.nvim", lazy = true },
      { "nvim-telescope/telescope.nvim", lazy = true },
      { "Hoffs/omnisharp-extended-lsp.nvim", lazy = true },
    },
  }
}

