return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- LSP servers
        "pyright",
        "bash-language-server",
        "lua-language-server",
        "json-lsp",
        "yaml-language-server",
        "marksman",
        "dockerfile-language-server",
        "taplo",
        
        -- Formatters
        "black",
        "prettier",
        "stylua",
        "shfmt",
        
        -- Linters
        "ruff",
        "shellcheck",
      },
    },
  },
}