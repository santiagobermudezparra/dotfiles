-- Salesforce development plugins
-- sf.nvim activates automatically in Salesforce projects (sfdx-project.json / .forceignore)
-- Requires: sf CLI v2 (installed by run_once_after_install_salesforce.sh) and Java 21 (mise)
return {
  -- sf.nvim: Salesforce CLI integration
  {
    "xixiaofinland/sf.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("sf").setup({
        enable_hotkeys = false,
      })

      -- Wrapper to prevent "modifiable is off" errors in read-only buffers
      local function safe_sf_command(cmd)
        return function()
          local current_buf    = vim.api.nvim_get_current_buf()
          local was_modifiable = vim.bo[current_buf].modifiable
          if not was_modifiable then vim.bo[current_buf].modifiable = true end

          local ok, result = pcall(function() vim.cmd(cmd) end)

          if not was_modifiable then vim.bo[current_buf].modifiable = false end
          if not ok then
            vim.notify("SF command failed: " .. tostring(result), vim.log.levels.ERROR, { title = "sf.nvim" })
          end
        end
      end

      local map = vim.keymap.set
      map("n", "<leader>sp",  safe_sf_command("SF metadata push"),          { desc = "SF Push Metadata" })
      map("n", "<leader>sr",  safe_sf_command("SF metadata retrieve"),      { desc = "SF Retrieve Metadata" })
      map("n", "<leader>sta", safe_sf_command("SF apex test run_all"),      { desc = "SF Run All Apex Tests" })
      map("n", "<leader>stt", safe_sf_command("SF apex test run_current"),  { desc = "SF Run Current Apex Test" })
      map("n", "<leader>so",  safe_sf_command("SF org open"),               { desc = "SF Open Org" })
      map("n", "<leader>sl",  safe_sf_command("SF org list"),               { desc = "SF List Orgs" })
    end,
  },

  -- toggleterm: floating terminal for sf CLI output
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      open_mapping = [[<c-\>]],
      direction    = "float",
      float_opts   = { border = "curved" },
    },
  },
}
