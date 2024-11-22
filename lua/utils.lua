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

M.override_hl_groups = function()
	-- Override the default highlight groups for Git diffs
	vim.api.nvim_set_hl(0, "DiffAdd", { fg = "NONE", bg = "#1E2D1E" })
	vim.api.nvim_set_hl(0, "DiffDelete", { fg = "NONE", bg = "#452828" })
	vim.api.nvim_set_hl(0, "DiffTextChange", { fg = "NONE", bg = "#454528" })
end

M.override_all = function()
	M.override_filetype()
	M.override_hl_groups()
end

return M
