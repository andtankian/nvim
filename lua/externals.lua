local lsps = {
	"lua_ls",
	"ts_ls",
	"jsonls",
	"terraformls",
	"bashls",
	"graphql",
	"pylsp",
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
	lsps = lsps,
	formatters = formatters,
	linters = linters,
}
