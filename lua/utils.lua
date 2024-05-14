local M = {}

-- util keymapping function
M.map = function(mode, key, action, opts)
	vim.keymap.set(mode, key, action, opts)
end

M.override_filetype = function()
	vim.filetype.add({
		extension = {
			tfvars = "terraform",
		},
	})
end

return M
