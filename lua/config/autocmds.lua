local function close_nvim_tree()
	require("nvim-tree.api").tree.close()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = close_nvim_tree })
