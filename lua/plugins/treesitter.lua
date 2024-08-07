return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			ensure_installed = {
				"lua",
				"typescript",
				"javascript",
				"tsx",
				"terraform",
        "vimdoc"
			},
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
}
