return {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = {
		".stylua.toml",
	},
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
				path = {
					"lua/?.lua",
					"lua/?/init.lua",
				},
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
					-- "${3rd}/luv/library",
				},
			},
		},
	},
}
