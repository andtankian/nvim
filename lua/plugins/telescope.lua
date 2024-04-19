return {
	"nvim-telescope/telescope.nvim",
	-- tag = "0.1.6",
	dependencies = {

		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		{
			"nvim-telescope/telescope-live-grep-args.nvim",
			-- This will not install any breaking changes.
			-- For major updates, this must be adjusted manually.
			version = "^1.0.0",
		},
	},
	config = function()
		local telescope = require("telescope")

		telescope.setup({
			defaults = {
				sorting_strategy = "ascending",
				selection_strategy = "follow",
				layout_config = {
					height = 0.9,
					width = 0.9,
					preview_cutoff = 120,
					prompt_position = "top",
				},
				prompt_prefix = " 🔎  ",
				selection_caret = "  ",
				multi_icon = "󰐾 ",
				border = {},
				path_display = {
					shorten = {
						len = 3,
					},
				},
				mappings = {
					i = {
						["<C-Down>"] = require("telescope.actions").cycle_history_next,
						["<C-Up>"] = require("telescope.actions").cycle_history_prev,
					},
				},
			},
			pickers = {
				git_status = {
					selection_strategy = "follow",
				},
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
		telescope.load_extension("live_grep_args")

		local set = vim.keymap.set
		local builtin = require("telescope.builtin")
		local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")

		set("n", "<leader>ff", builtin.find_files, {})
		set("n", "<leader>fb", builtin.buffers, {})
		set("n", "<leader>fw", telescope.extensions.live_grep_args.live_grep_args, {})
		set("n", "<leader>gt", builtin.git_status, {})
		set("n", "<leader>fgb", builtin.git_branches, {})
		set("n", "<leader>fgs", builtin.git_stash, {})
		set("n", "<leader>fgc", builtin.git_commits, {})
		set("n", "<leader>fgh", builtin.git_bcommits, {})
		set("n", "<leader>gc", live_grep_args_shortcuts.grep_word_under_cursor, {})
		set("n", "<leader>fr", builtin.resume, {})
		set("n", "<leader>fo", builtin.oldfiles, {})
	end,
}
