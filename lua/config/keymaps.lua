local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ============================================================================
-- Leader Keys
-- ============================================================================

-- Disable space in normal/visual mode (since it's our leader)
keymap({ "n", "v" }, "<Space>", "<Nop>", opts)

-- ============================================================================
-- General Editing
-- ============================================================================

-- Clear search highlighting
keymap("n", "<Esc>", "<cmd>noh<CR>", { desc = "Clear search highlighting" })

-- Better up/down (move by visual lines, not actual lines)
keymap({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move selected lines up/down in visual mode
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Better indenting (stay in visual mode)
keymap("v", "<", "<gv", { desc = "Indent left" })
keymap("v", ">", ">gv", { desc = "Indent right" })

-- Paste without yanking in visual mode
keymap("x", "p", [["_dP]], { desc = "Paste without yank" })

-- Keep cursor centered when scrolling
keymap("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
keymap("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })

-- Keep search results centered
keymap("n", "n", "nzzzv", { desc = "Next result (centered)" })
keymap("n", "N", "Nzzzv", { desc = "Previous result (centered)" })

-- Join lines without moving cursor
keymap("n", "J", "mzJ`z", { desc = "Join lines" })

-- ============================================================================
-- Window Navigation
-- ============================================================================

-- Navigate between windows
keymap("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- ============================================================================
-- Buffer Navigation
-- ============================================================================

-- Navigate between buffers
keymap("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
keymap("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })

-- Close buffers
keymap("n", "<leader>x", "<cmd>bp|bd #<CR>", { desc = "Close current buffer" })

-- Close all buffers except protected ones
local function delete_all_buffers_except_protected()
	local protected_filetypes = {
		"NvimTree",
		"neo-tree",
		"TelescopePrompt",
		"qf",
		"help",
		"terminal",
		"toggleterm",
		"lazy",
		"mason",
		"notify",
		"noice",
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

			-- Also protect modified buffers
			if vim.bo[bufnr].modified then
				should_delete = false
			end

			if should_delete and vim.api.nvim_buf_is_valid(bufnr) then
				pcall(vim.api.nvim_buf_delete, bufnr, { force = false })
			end
		end
	end
end

keymap("n", "<leader>X", delete_all_buffers_except_protected, { desc = "Close all buffers except protected" })

-- ============================================================================
-- Quick Substitution
-- ============================================================================

-- Replace word under cursor
keymap(
	"n",
	"<leader>rw",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Replace word under cursor" }
)

-- Replace selection
keymap("v", "<leader>rw", [["hy:%s/<C-r>h/<C-r>h/gc<left><left><left>]], { desc = "Replace selection" })

-- ============================================================================
-- Terminal Mode
-- ============================================================================

-- Exit terminal mode
keymap("t", "<C-x>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- ============================================================================
-- Better Line Start/End
-- ============================================================================

-- Go to start/end of line easier
keymap({ "n", "v" }, "H", "^", { desc = "Go to start of line" })
keymap({ "n", "v" }, "L", "$", { desc = "Go to end of line" })

-- ============================================================================
-- Miscellaneous
-- ============================================================================

-- Better * and # (search word under cursor without jumping)
keymap("n", "*", "*N", { desc = "Search word under cursor" })
keymap("n", "#", "#N", { desc = "Search word under cursor backward" })
