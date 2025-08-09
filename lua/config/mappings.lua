local helpers = require("config.utils.helpers")

local g = vim.g

g.mapleader = " "
g.maplocalleader = " "

helpers.keymap("n", "<Space>", "")
helpers.keymap("n", "<Esc>", "<cmd> noh <CR>")
helpers.keymap("n", "<C-h>", "<C-w>h")
helpers.keymap("n", "<C-l>", "<C-w>l")
helpers.keymap("n", "<C-j>", "<C-w>j")
helpers.keymap("n", "<C-k>", "<C-w>k")

-- Buffer navigation
helpers.keymap("n", "<Tab>", "<cmd>bnext<CR>")
helpers.keymap("n", "<S-Tab>", "<cmd>bprevious<CR>")
helpers.keymap("n", "<leader>x", "<cmd>bp|bd #<CR>")

local function delete_all_buffers_except_protected()
	local protected_filetypes = {
		"NvimTree", -- File explorer
		"TelescopePrompt", -- Telescope
		"qf", -- Quickfix
		"help", -- Help pages
		"terminal", -- Terminal buffers
		"codecompanion",
	}

	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(bufnr) then
			local buftype = vim.bo[bufnr].buftype
			local filetype = vim.bo[bufnr].filetype

			local should_delete = true
			-- Check if buffer is in protected filetypes
			for _, protected in ipairs(protected_filetypes) do
				if filetype == protected or buftype == protected then
					should_delete = false
					break
				end
			end

			if should_delete and vim.api.nvim_buf_is_valid(bufnr) then
				vim.api.nvim_buf_delete(bufnr, { force = false })
			end
		end
	end
end

helpers.keymap("n", "<leader>X", delete_all_buffers_except_protected)
