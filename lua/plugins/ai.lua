return {
	{
		"github/copilot.vim",
		config = function()
			local g = vim.g
			g.copilot_no_tab_map = true
			vim.keymap.set(
				"i",
				"<C-j>",
				'copilot#Accept("<cr>")',
				{ silent = true, expr = true, replace_keycodes = false, desc = "Accept copilot suggestion" }
			)
		end,
	},
}
