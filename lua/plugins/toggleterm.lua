local utils = require("utils")

return {
	"akinsho/toggleterm.nvim", -- float terminal plugin
	version = "*",
	opts = {
		open_mapping = "<C-t>",
		direction = "float",
	},
	config = function(_, opts)
		require("toggleterm").setup(opts)

    -- Exit terminal mode with <C-x> inside terminal
		utils.map("t", "<C-x>", "<C-\\><C-n>", { desc = "Exit terminal mode", noremap = true})
	end,
}
