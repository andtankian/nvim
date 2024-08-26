return {
	{
		"NvChad/nvim-colorizer.lua",
	},
	-- {
	-- 	"xiyaowong/transparent.nvim",
	-- 	config = function()
	-- 		require("transparent").setup()
	-- 	end,
	-- },
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		dependencies = {
			"xiyaowong/transparent.nvim",
		},
		opts = {},
		config = function()
			vim.cmd("colorscheme catppuccin-macchiato")
		end,
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				on_highlights = function(hl, c)
					local prompt = "#2d3149"
					hl.TelescopeNormal = {
						bg = c.bg_dark,
						fg = c.fg_dark,
					}
					hl.TelescopeBorder = {
						bg = c.bg_dark,
						fg = c.bg_dark,
					}
					hl.TelescopePromptNormal = {
						bg = prompt,
					}
					hl.TelescopePromptBorder = {
						bg = prompt,
						fg = prompt,
					}
					hl.TelescopePromptTitle = {
						bg = prompt,
						fg = prompt,
					}
					hl.TelescopePreviewTitle = {
						bg = c.bg_dark,
						fg = c.bg_dark,
					}
					hl.TelescopeResultsTitle = {
						bg = c.bg_dark,
						fg = c.bg_dark,
					}
				end,
			})

			-- vim.cmd("colorscheme tokyonight-night")
		end,
	},
}
