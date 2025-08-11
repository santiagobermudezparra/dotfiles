return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Python
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
        
        -- Bash
        bashls = {},
        
        -- Lua (for Neovim config)
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                callSnippet = "Replace",
              },
              diagnostics = {
                globals = { "vim" },
              },
            },
          },
        },
        
        -- JSON
        jsonls = {},
        
        -- YAML
        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false,
            },
          },
        },
        
        -- Markdown
        marksman = {},
        
        -- Docker
        dockerls = {},
        
        -- TOML
        taplo = {},
      },
    },
  },
}