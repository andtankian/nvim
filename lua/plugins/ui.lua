return {
	{
		"nvchad/ui",
		config = function()
			require("nvchad")
		end,
	},
	{
		"nvchad/base46",
		lazy = true,
		build = function()
			require("base46").load_all_highlights()
		end,
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown", "codecompanion" },
		opts = {
			render_modes = true,
			sign = {
				enabled = false,
			},
		},
	},
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = {
			auto_scroll = false,
		},
		keys = {
			{
				"<C-t>",
				"<cmd>1ToggleTerm direction=float<cr>",
				desc = "Toggle terminal",
				mode = { "n", "t" },
			},
			{
				"<leader>tn",
				function()
					local random_num = math.random(2, 999)
					vim.cmd(random_num .. "ToggleTerm direction=horizontal")
				end,
				desc = "New horizontal terminal",
				mode = { "n" },
			},
			{
				"<leader>ta",
				"<cmd>ToggleTerm direction=horizontal<cr>",
				desc = "Toggle all terminals",
				mode = { "n" },
			},
			{
				"<leader>ts",
				"<cmd>TermSelect<cr>",
				desc = "Select terminal",
				mode = { "n" },
			},
			{
				"<C-x>",
				"<C-\\><C-n>",
				mode = "t",
				desc = "Exit terminal mode",
			},
		},
	},
}
