return {
	"github/copilot.vim",
	config = function()
		local g = vim.g
		local keymap = vim.keymap

		g.copilot_no_tab_map = true
		keymap.set(
			"i",
			"<C-j>",
			'copilot#Accept("<cr>")',
			{ noremap = true, silent = true, expr = true, replace_keycodes = false }
		)
	end,
}
