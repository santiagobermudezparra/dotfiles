-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.lazygit_config = false

vim.g.snacks_animate = false
vim.g.lazyvim_check_order = false

vim.opt.ignorecase = true

-- scrolling
vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.scrolloff = 8



-- Enable completion
vim.opt.completeopt = "menu,menuone,noselect"

-- Better completion experience
vim.opt.pumheight = 10

-- Enable mouse support
vim.opt.mouse = "a"

-- Case insensitive searching UNLESS /C or capital in search
vim.opt.smartcase = true

-- Faster completion (4000ms default)
vim.opt.updatetime = 250

-- Always show the signcolumn, otherwise it would shift the text each time
vim.opt.signcolumn = "yes"

-- wrap / break

-- opt.textwidth = 80
-- opt.linebreak = true

-- indentation

-- o.expandtab = true              -- convert tabs to spaces
-- o.tabstop = 4                   -- insert 4 spaces for a tab
-- o.shiftwidth = 4                -- the number of spaces inserted for each indentation
-- o.smartindent = true

-- windows
-- vim.o.splitbelow = true
-- vim.o.splitright = true

-- completion
-- vim.o.timeoutlen = 300 -- time to wait for a mapped sequence to complete
--
-- g.vim_markdown_conceal = 0
--
--
-- opt.vim_markdown_conceal = 0
--
-- vim.g.mkdp_browser = "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge"
