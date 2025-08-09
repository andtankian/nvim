return {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_dir = vim.loop.cwd(),
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
				},
			},
			telemetry = {
				enable = false,
			},
		},
	},
}
