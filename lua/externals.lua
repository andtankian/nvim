local lsps = {
	"lua_ls",
	"eslint",
	"ts_ls",
	"jsonls",
	"terraformls",
}

local formatters = {
	"prettier",
	"stylua",
	"yamlfmt",
}

local linters = {
	"tflint",
}

return {
	lsps = lsps,
	formatters = formatters,
	linters = linters,
}
