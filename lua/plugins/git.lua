return {
	{
		"tpope/vim-fugitive",
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "BufEnter",
		keys = {
			{
				"]c",
				function()
					local gs = require("gitsigns")

					if vim.wo.diff then
						return "]c"
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return "<Ignore>"
				end,
				desc = "Go to next hunk",
				{ expr = true },
			},
			{
				"[c",
				function()
					local gs = require("gitsigns")

					if vim.wo.diff then
						return "[c"
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return "<Ignore>"
				end,
				desc = "Go to previous hunk",
				{ expr = true },
			},
			{
				"<leader>hs",
				function()
					require("gitsigns").stage_hunk()
				end,
				desc = "Stage hunk",
			},
			{
				"<leader>hr",
				function()
					require("gitsigns").reset_hunk()
				end,
				desc = "Reset hunk",
			},
			{
				"<leader>hp",
				function()
					require("gitsigns").preview_hunk()
				end,
				desc = "Preview hunk",
			},
			{
				"<leader>hb",
				function()
					require("gitsigns").blame_line({ full = true })
				end,
				desc = "Blame line",
			},
			{
				"<leader>hd",
				function()
					require("gitsigns").diffthis()
				end,
				desc = "Diff this",
			},
		},
		opts = {
			current_line_blame = true,
		},
	},
	{
		"pwntester/octo.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
		opts = {},
	},
	{
		"sindrets/diffview.nvim",
		keys = {
			{ "<leader>dv", "<cmd>DiffviewOpen<cr>", desc = "Open diffview" },
			{ "<leader>dg", "<cmd>DiffviewClose<cr>", desc = "Close diffview" },
			{ "<leader>hD", "<cmd>DiffviewFileHistory %<cr>", desc = "Current File history" },
		},
		opts = {},
	},
}
