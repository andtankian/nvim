return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	opts = function()
		local mappings = {
			["<Tab>"] = {
				"toggle_node",
				nowait = false,
			},
		}

		return {
			window = {
				mapping_options = {
					noremap = true,
					nowait = true,
				},
				mappings = mappings,
			},
			event_handlers = {
				{
					event = "file_opened",
					handler = function()
						require("neo-tree.command").execute({ action = "close" })
					end,
				},
			},
		}
	end,
	config = function(_, opts)
		require("neo-tree").setup(opts)

		local mapping_options = {
			noremap = true,
			silent = true,
		}

		vim.keymap.set(
			"n",
			"<C-n>",
			":Neotree position=left toggle=true source=filesystem reveal_force_cwd=true<CR>",
			mapping_options
		)
		vim.keymap.set(
			"n",
			"<leader>e",
			":Neotree position=left source=filesystem reveal_force_cwd=true<CR>",
			mapping_options
		)
	end,
}
