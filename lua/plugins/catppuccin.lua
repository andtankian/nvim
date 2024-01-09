return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	dependencies = {
		"xiyaowong/transparent.nvim",
	},
	config = function()
		vim.cmd.colorscheme("catppuccin-mocha")
		require("transparent").setup()
	end,
}
