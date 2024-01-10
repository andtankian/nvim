return {
	"nvimtools/none-ls.nvim",
	config = function()
		local nonels = require("null-ls")

		local builtins = nonels.builtins

		nonels.setup({
			sources = {
				builtins.formatting.prettier.with({
					filetypes = { "javascript", "typescript", "json" },
				}),
				builtins.formatting.stylua,
			},
		})
	end,
}
