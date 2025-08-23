return {
	cmd = { "pylsp" },
	filetypes = { "python" },
	root_dir = vim.loop.cwd(),
	settings = {
		pylsp = {
			plugins = {
				flake8 = {
					enabled = true,
					maxLineLength = 120, -- Set a new maximum line length
				},
				pycodestyle = {
					enabled = true,
					maxLineLength = 120, -- Set a new maximum line length if pycodestyle is used
				},
			},
		},
	},
}
