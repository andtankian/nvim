return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		local bl = require("bufferline")
		bl.setup()

		local keymap = vim.keymap
		local mapping_options = { silent = true, noremap = true }

		function close_all_buffers()
			for _, e in ipairs(bl.get_elements().elements) do
				vim.schedule(function()
					vim.cmd("bd " .. e.id)
				end)
			end
		end

		keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>", mapping_options)
		keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", mapping_options)
		keymap.set("n", "<leader>x", ":bd|bp <CR>", mapping_options)
		keymap.set("n", "<leader>X", "<cmd>lua close_all_buffers()<CR>", mapping_options)
	end,
}
