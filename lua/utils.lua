local M = {}

-- util keymapping function
M.map = function(mode, key, action, opts)
  vim.api.nvim_set_keymap(mode, key, action, opts)
end

return M
