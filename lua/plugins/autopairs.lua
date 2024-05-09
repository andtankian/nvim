return {
	{
		"windwp/nvim-ts-autotag", -- Auto close and auto rename html tags
	},
	{
		"windwp/nvim-autopairs", -- Auto close and auto rename brackets
		event = "InsertEnter", -- Load on entering insert mode
		opts = {},
	},
	{
		"kylechui/nvim-surround", -- Surround text with brackets, quotes, etc.
		version = "*",
		event = "VeryLazy", -- Load on demand
		opts = {},
	},
}
