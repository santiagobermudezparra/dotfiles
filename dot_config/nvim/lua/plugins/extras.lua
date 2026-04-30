return {
  { import = "lazyvim.plugins.extras.lang.json"   },
  { import = "lazyvim.plugins.extras.lang.toml"   },
  { import = "lazyvim.plugins.extras.lang.yaml"   },
  -- python extra omitted: pulls in ruff which requires build tools not
  -- present on all Linux machines. Install python tools per-project instead.
  { import = "lazyvim.plugins.extras.lang.docker" },
  { import = "lazyvim.plugins.extras.editor.telescope" },
}
