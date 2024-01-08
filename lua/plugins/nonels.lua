return {
	"nvimtools/none-ls.nvim",
	config = function()
		local nonels = require("null-ls")

		local builtins = nonels.builtins

		nonels.setup({
			sources = {
				builtins.formatting.stylua,
				builtins.formatting.prettierd,
			},
		})
	end,
}
