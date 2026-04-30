return {
  -- Mason: auto-install LSP servers and formatters
  {
    "mason-org/mason.nvim", -- renamed from williamboman/mason.nvim
    opts = {
      ensure_installed = {
        "typescript-language-server", -- ts_ls (typescript.lua)
        "yaml-language-server",       -- yamlls
        "json-lsp",                   -- jsonls
        "bash-language-server",       -- bashls
        "marksman",                   -- markdown
        "eslint-lsp",                 -- eslint (typescript.lua)
        "prettier",                   -- formatter (formatting.lua)
      },
    },
  },

  -- SchemaStore for JSON and YAML schema validation
  { "b0o/SchemaStore.nvim", lazy = true },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {},
        marksman = {
          settings = {
            marksman = {
              hover = {
                openCommand = "xdg-open",
              },
            },
          },
        },
        jsonls = {
          settings = {
            json = {
              schemas  = function() return require("schemastore").json.schemas() end,
              validate = { enable = true },
            },
          },
        },
        yamlls = {
          settings = {
            yaml = {
              schemaStore = { enable = false, url = "" },
              schemas     = function() return require("schemastore").yaml.schemas() end,
            },
          },
        },
      },
    },
  },
}
