local externals = require("config.externals")

local ensure_installed =
	vim.iter({ externals.formatters, externals.linters, vim.tbl_values(externals.lsp) }):flatten():totable()

return {
	{
		cmd = "Mason",
		"mason-org/mason.nvim",
		opts = {},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = {
			ensure_installed = ensure_installed,
		},
		dependencies = {
			"mason-org/mason.nvim",
		},
	},
}
