return {

	{
		"nvim-treesitter/nvim-treesitter",
		-- Pin to last stable tag that uses gcc compilation.
		-- HEAD switched to tree-sitter CLI which requires GLIBC 2.39 (Ubuntu 22.04 has 2.35).
		tag = "v0.10.0",
		build = ":TSUpdate",
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
