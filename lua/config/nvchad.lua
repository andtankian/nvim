dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "blink")
dofile(vim.g.base46_cache .. "colors")
dofile(vim.g.base46_cache .. "devicons")
dofile(vim.g.base46_cache .. "statusline")
dofile(vim.g.base46_cache .. "syntax")
dofile(vim.g.base46_cache .. "telescope")
dofile(vim.g.base46_cache .. "nvimtree")
dofile(vim.g.base46_cache .. "treesitter")
dofile(vim.g.base46_cache .. "lsp")

for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
	dofile(vim.g.base46_cache .. v)
end
