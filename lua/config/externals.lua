local lsp = {
	lua_ls = "lua-language-server",
	ts_ls = "typescript-language-server",
	jsonls = "json-lsp",
	graphql = "graphql-language-service-cli",
	pylsp = "python-lsp-server",
	terraformls = "terraform-ls",
}

local formatters = {
	"prettier",
	"stylua",
	"yamlfmt",
	"black",
}

local linters = {
	"tflint",
}

return {
	lsp = lsp,
	formatters = formatters,
	linters = linters,
}
