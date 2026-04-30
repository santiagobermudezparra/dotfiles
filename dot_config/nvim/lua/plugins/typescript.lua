-- TypeScript/JavaScript LSP + ESLint
-- ts_ls is configured directly via nvim-lspconfig (do NOT enable LazyVim's
-- TypeScript extra alongside this — it installs a conflicting TS server)
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ts_ls = {
          filetypes = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
          },
          root_dir = require("lspconfig.util").root_pattern(
            "tsconfig.json",
            "jsconfig.json",
            "package.json",
            ".git"
          ),
        },
        eslint = {
          settings = {
            packageManager = "npm",
          },
          on_attach = function(_, bufnr)
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer  = bufnr,
              command = "EslintFixAll",
            })
          end,
        },
      },
    },
  },
}
