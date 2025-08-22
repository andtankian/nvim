local function close_nvim_tree()
	require("nvim-tree.api").tree.close()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = close_nvim_tree })

vim.api.nvim_create_autocmd("User", {
	pattern = "TelescopePreviewerLoaded",
	callback = function(args)
		-- Only apply line numbers to regular files, not help files
		if args.data.filetype ~= "help" then
			vim.wo.number = true
		end
	end,
})
