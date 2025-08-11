return {
	cmd = { "typescript-language-server", "--stdio" },
	root_dir = vim.loop.cwd(),
	filetypes = {
		"typescript",
		"typescriptreact",
		"javascript",
		"javascriptreact",
	},
}
