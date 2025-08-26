-- Apply only when it's neovide
if vim.g.neovide then
	vim.g.neovide_input_use_logo = 1
	vim.api.nvim_set_keymap("", "<D-v>", "+p<CR>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("!", "<D-v>", "<C-R>+", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("t", "<D-v>", "<C-R>+", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("v", "<D-v>", "<C-R>+", { noremap = true, silent = true })
	vim.g.neovide_cursor_animation_length = 0.08
	vim.g.neovide_cursor_animate_command_line = false
	vim.g.neovide_cursor_trail_size = 0
end
