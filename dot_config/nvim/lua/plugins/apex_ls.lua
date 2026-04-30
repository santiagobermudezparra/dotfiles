-- Apex Language Server
-- JAR is downloaded to a fixed path by run_once_after_install_salesforce.sh
-- (no chezmoi template variable needed on Linux — path is always the same)
local jar_path = vim.fn.expand("~/.local/share/nvim/apex-ls/apex-jorje-lsp.jar")

-- Only configure apex_ls if the JAR exists; avoids noisy errors on machines
-- where the download hasn't run yet or Salesforce dev isn't needed.
if vim.fn.filereadable(jar_path) == 0 then
  return {}
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        apex_ls = {
          cmd = {
            "java",
            "-cp", jar_path,
            "-Ddebug.internal.errors=true",
            "-Ddebug.semantic.errors=true",
            "-Dlwc.typegeneration.disabled=true",
            "apex.jorje.lsp.ApexLanguageServerLauncher",
          },
          filetypes = { "apexcode" },
          root_dir  = function(fname)
            return require("lspconfig.util").root_pattern("sfdx-project.json")(fname)
          end,
        },
      },
    },
  },
}
