return {
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      filters = {
        dotfiles = false,    -- Show hidden files by default
        git_clean = false,   -- Show git-ignored files
        no_buffer = false,
        custom = {},
      },
      view = {
        width = 35,
        side = "left",
        number = false,
        relativenumber = false,
      },
      renderer = {
        highlight_git = true,
        icons = {
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
          },
          glyphs = {
            default = "",
            symlink = "",
            git = {
              unstaged = "✗",
              staged = "✓",
              unmerged = "",
              renamed = "➜",
              untracked = "★",
              deleted = "",
              ignored = "◌",
            },
          },
        },
      },
      git = {
        enable = true,
        ignore = false,    -- Show git-ignored files
        timeout = 400,
      },
      actions = {
        open_file = {
          quit_on_open = false,
          resize_window = true,
        },
      },
    },
  },
}