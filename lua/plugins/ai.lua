local utils = require("utils")

return {
	{
		"supermaven-inc/supermaven-nvim",
		opts = {
			keymaps = {
				accept_suggestion = "<C-j>",
				clear_suggestion = "<C-]>",
				accept_word = "<C-k>",
			},
		},
	},
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"hrsh7th/nvim-cmp",
			"nvim-telescope/telescope.nvim",
			{ "stevearc/dressing.nvim", opts = {} },
		},
		opts = {
			display = {
				chat = {
					show_header_separator = false,
				},
			},
			strategies = {
				chat = {
					adapter = "anthropic",
					slash_commands = {
						["buffer"] = {
							opts = {
								provider = "telescope",
							},
						},
					},
				},
				inline = {
					adapter = "anthropic",
				},
				agent = {
					adapter = "anthropic",
				},
			},
		},
		config = function(_, opts)
			require("codecompanion").setup(opts)

			utils.map("n", "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
			utils.map("v", "<leader>cc", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })
			vim.api.nvim_create_user_command("Cc", "CodeCompanion <args>", { nargs = "*" })
		end,
	},
}
