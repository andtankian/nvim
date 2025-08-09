local externals = require("config.externals")
local helpers = require("config.utils.helpers")

return {
	{
		"mason-org/mason.nvim",
		opts = {},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = {
			ensure_installed = vim.tbl_flatten({
				externals.formatters,
				externals.linters,
				helpers.tbl_values(externals.lsp),
			}),
		},
		dependencies = {
			"mason-org/mason.nvim",
		},
	},
	{
		"ravitemer/mcphub.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		cmd = "MCPHub",
		build = "npm install -g mcp-hub@latest",
		opts = {},
	},
}
