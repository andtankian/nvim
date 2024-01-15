return {
	"jackMort/ChatGPT.nvim",
	event = "VeryLazy",
	opts = {
		popup_layout = {
			center = {
				width = "90%",
				height = "90%",
			},
		},
		openai_params = {
			model = "gpt-4-1106-preview",
			frequency_penalty = 0,
			presence_penalty = 0,
			max_tokens = 4096,
			temperature = 0,
			top_p = 1,
			n = 1,
		},
		openai_edit_params = {
			model = "gpt-4-1106-preview",
			frequency_penalty = 0,
			presence_penalty = 0,
			max_tokens = 4096,
			temperature = 0,
			top_p = 1,
			n = 1,
		},
	},
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},

	config = function(_, opts)
		require("chatgpt").setup(opts)

		local keymap = vim.keymap

		keymap.set("n", "<leader>gpt", ":ChatGPT<CR>", { noremap = true, silent = true })
	end,
}
