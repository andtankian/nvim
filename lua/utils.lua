local M = {}

-- util keymapping function
M.map = function(mode, key, action, opts)
  vim.keymap.set(mode, key, action, opts)
end

return M
