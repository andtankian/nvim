local M = {
	ui = {
		statusline = {
			theme = "default",
			separator_style = "round",
			order = { "mode", "file", "git", "diagnostics", "%=", "lsp", "cwd", "cursor" },
		},
		tabufline = {
			enabled = false,
		},
	},
	base46 = {
		theme = "zenburn",
	},
}

return M
