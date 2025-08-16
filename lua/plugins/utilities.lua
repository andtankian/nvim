return {
	{
		"folke/todo-comments.nvim",
		cmd = "TodoTelescope",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = true,
	},
	{ "echasnovski/mini.surround", version = "*", config = true, event = "InsertEnter" },
	{
		"echasnovski/mini.ai",
		version = "*",
		config = true,
	},
	{
		"echasnovski/mini.indentscope",
		version = "*",
		opts = {
			symbol = "│",
			draw = {
				predicate = function(scope)
					return not scope.body.is_incomplete and vim.bo.filetype ~= "NvimTree"
				end,
			},
		},
		ft = { "lua", "javascript", "typescript", "json", "python" },
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		config = true,
	},
	{
		"tversteeg/registers.nvim",
		config = true,
		keys = {
			{ '"', mode = { "n", "v" } },
			{ "<C-R>", mode = "i" },
		},
	},
	{
		"kevinhwang91/nvim-ufo",
		ft = { "lua", "javascript", "typescript", "json", "python" },
		dependencies = { "kevinhwang91/promise-async" },
		opts = {},
	},
	{
		"tpope/vim-abolish",
	},
	{
		"andtankian/nxtest.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {
			terminal_position = "vertical",
		},
	},
}
