local lsps = {
	"lua_ls",
	"eslint",
	"tsserver",
	"jsonls",
}

local formatters = {
	"prettier",
	"stylua",
  "yamlfmt"
}

local linters = {}

return {
	lsps = lsps,
	formatters = formatters,
	linters = linters,
}
