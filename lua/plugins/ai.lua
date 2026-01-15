return {
	{
		"github/copilot.vim",
		event = "VeryLazy",
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
	{
		"olimorris/codecompanion.nvim",
		version = "^18.0.0",
		opts = {
			extensions = {
				mcphub = {
					callback = "mcphub.extensions.codecompanion",
					opts = {
						make_vars = true,
						make_slash_commands = true,
						show_result_in_chat = true,
					},
				},
			},
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"ravitemer/mcphub.nvim",
		},
		keys = {
			{
				"<leader>cc",
				":CodeCompanionChat Toggle<CR>",
				desc = "Open Code Companion",
			},
		},
	},
}
