return {
	{
		"akinsho/bufferline.nvim", -- tabs to list buffers
		version = "*",
		dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "BufEnter", -- only load when a buffer is opened
		keys = {
			{
				"<Tab>",
				":BufferLineCycleNext<CR>",
				desc = "Go to next buffer",
			},
			{
				"<S-Tab>",
				":BufferLineCyclePrev<CR>",
				desc = "Go to previous buffer",
			},
			{
				"<leader>x",
				":bd|bp <CR>",
				desc = "Close buffer",
			},
			{
				"<leader>X",
				function()
					local bl = require("bufferline")
					for _, e in ipairs(bl.get_elements().elements) do
						vim.schedule(function()
							vim.cmd("bd " .. e.id)
						end)
					end
				end,
				desc = "Close all buffers",
			},
		},
		opts = {},
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VimEnter",
		opts = {
			options = {
				theme = "dracula",
			},
		},
	},
}
