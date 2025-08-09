local externals = require("config.externals")

local ensure_installed =
	vim.iter({ externals.formatters, externals.linters, vim.tbl_values(externals.lsp) }):flatten():totable()

return {
	{
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
