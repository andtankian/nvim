local lsps = {
	"lua_ls",
	"ts_ls",
	"jsonls",
	"terraformls",
	"bashls",
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
