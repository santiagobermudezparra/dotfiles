return {
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      filters = {
        dotfiles = false,  -- show dotfiles
        custom = {},       -- no custom filters
      },
      git = {
        enable = true,
        ignore = false,    -- show git-ignored files
      },
      view = {
        width = 35,
        side = "left",
      },
    },
  },
}
