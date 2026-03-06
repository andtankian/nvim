local externals = require("config.externals")

return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		lazy = false,
		config = function()
			require("nvim-treesitter").setup({})
			require("nvim-treesitter").install(externals.parsers)

			vim.api.nvim_create_autocmd("FileType", {
				callback = function(ev)
					local max_filesize = 100 * 1024 -- 100 KB
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(ev.buf))
					if ok and stats and stats.size > max_filesize then return end
					pcall(vim.treesitter.start)
					vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "VeryLazy",
		opts = {},
	},
}
