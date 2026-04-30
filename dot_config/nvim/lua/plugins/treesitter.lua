return {

	{
		"nvim-treesitter/nvim-treesitter",
		-- v0.9.3: last version using gcc; HEAD switched to tree-sitter CLI (needs GLIBC 2.39)
		commit = "13be7a022997446bf96892bf1ac95784681a02e1",
		opts = {
			ensure_installed = {
				"bash",
				"vimdoc",
				"html",
				"json",
				"lua",
				-- "markdown",
				-- "markdown_inline",
				"python",
				"query",
				"regex",
				"vim",
				"yaml",
				"go",
				"bicep",
				"terraform",
				"c_sharp",
			},
			-- Disable terraform treesitter on fixture files
			highlight = {
				disable = function(lang)
					local buf_name = vim.fn.expand("%")
					if lang == "terraform" and string.find(buf_name, "fixture") then
						return true
					end
				end,
			},
		},
	},
}
