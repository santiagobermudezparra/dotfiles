-- conform.nvim: format-on-save with prettier for JS/TS/web files
return {
  {
    "stevearc/conform.nvim",
    opts = {
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        javascript      = { "prettier" },
        javascriptreact = { "prettier" },
        typescript      = { "prettier" },
        typescriptreact = { "prettier" },
        json            = { "prettier" },
        css             = { "prettier" },
        html            = { "prettier" },
      },
    },
  },
}
