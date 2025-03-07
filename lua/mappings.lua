local utils = require("utils")

local g = vim.g

g.mapleader = " "
g.maplocalleader = " "

utils.map("n", "<Space>", "")
utils.map("n", "<Esc>", "<cmd> noh <CR>")
utils.map("n", "<C-h>", "<C-w>h")
utils.map("n", "<C-l>", "<C-w>l")
utils.map("n", "<C-j>", "<C-w>j")
utils.map("n", "<C-k>", "<C-w>k")

-- Buffer navigation
utils.map("n", "<Tab>", "<cmd>bnext<CR>")
utils.map("n", "<S-Tab>", "<cmd>bprevious<CR>")
utils.map("n", "<leader>x", "<cmd>bp|bd #<CR>")

-- Delete all buffers except protected ones
---@diagnostic disable-next-line: unused-local, unused-function
function Delete_all_buffers_except_protected()
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

utils.map("n", "<leader>X", "<cmd>lua Delete_all_buffers_except_protected()<CR>")
