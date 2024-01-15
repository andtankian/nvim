return {
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local telescope = require("telescope")

			telescope.setup({
				defaults = {
					vimgrep_arguments = {
						"rg",
						"-L",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
					},
					prompt_prefix = "    ",
					selection_caret = "  ",
					initial_mode = "insert",
					selection_strategy = "row",
					sorting_strategy = "ascending",
					layout_strategy = "horizontal",
					layout_config = {
						horizontal = {
							prompt_position = "top",
						},
						width = 0.9,
						height = 0.9,
					},
					file_sorter = require("telescope.sorters").get_fuzzy_file,
					file_ignore_patterns = { "node_modules" },
					generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
					path_display = { "truncate" },
					winblend = 0,
					border = {},
					borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
					color_devicons = true,
					file_previewer = require("telescope.previewers").vim_buffer_cat.new,
					grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
					qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
				},
				extensions = {
					fzf = {
						fuzzy = false,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
			})

			telescope.load_extension("fzf")

			local keymap = vim.keymap
			local builtin = require("telescope.builtin")

			keymap.set("n", "<leader>ff", builtin.find_files, {})
			keymap.set("n", "<leader>fb", builtin.buffers, {})
			keymap.set("n", "<leader>fw", builtin.live_grep, {})
			keymap.set("n", "<leader>gt", builtin.git_status, {})
			keymap.set("n", "<leader>fgb", builtin.git_branches, {})
			keymap.set("n", "<leader>fgs", builtin.git_stash, {})
		end,
	},
}
