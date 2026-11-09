return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		ft = { "markdown" },
		opts = {
			-- Only non-default options
			-- Off by default; use :RenderMarkdown toggle / buf_toggle
			enabled = false,
			code = {
				left_pad = 2,
				right_pad = 2,
				width = "block",
				border = "thin",
			},
		},
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},
}
