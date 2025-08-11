return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {},  -- Bash support
        marksman = {  -- Markdown with custom settings
          settings = {
            marksman = {
              hover = {
                openCommand = "xdg-open",
              },
            },
          },
        },
      },
    },
  },
}