return {
	"akinsho/toggleterm.nvim",
	version = "*",
	opts = {
		open_mapping = "<C-t>",
		direction = "float",
	},
	config = function(_, opts)
		require("toggleterm").setup(opts)

		local keymap = vim.keymap

		keymap.set("t", "<C-x>", "<C-\\><C-n>")
	end,
}
