local lsp = {
	lua_ls = "lua-language-server",
	ts_ls = "typescript-language-server",
	jsonls = "json-lsp",
	terraformls = "terraform-ls",
	graphql = "graphql-language-service-cli",
	pylsp = "python-lsp-server",
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
