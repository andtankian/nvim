local externals = require("externals")

return {
	{
		"williamboman/mason.nvim",
		name = "mason",
		opts = {},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		name = "mason-lspconfig",
		dependencies = {
			"mason",
		},
		opts = {
			ensure_installed = externals.lsps,
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = {
			ensure_installed = vim.tbl_extend("force", externals.formatters, externals.linters),
		},
		dependencies = {
			"mason",
		},
	},
}
