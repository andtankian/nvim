local externals = require("config.externals")

-- Extract LSP server names from languages table
local lsp_servers = {}
for _, server_name in pairs(externals.languages) do
	table.insert(lsp_servers, server_name)
end

return {
	{
		"mason-org/mason.nvim",
		cmd = "Mason",
		opts = {},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependency = "mason-org/mason.nvim",
		opts = {
			ensure_installed = vim.list_extend(
				vim.list_extend(lsp_servers, externals.formatters),
				externals.debuggers
			),
		},
	},
}
