local utils = require("utils")

return {
	"nvim-telescope/telescope.nvim",
	-- tag = "0.1.6",
	dependencies = {

		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		{ "xiyaowong/telescope-emoji.nvim" },
		{
			"nvim-telescope/telescope-live-grep-args.nvim",
			-- This will not install any breaking changes.
			-- For major updates, this must be adjusted manually.
			version = "^1.0.0",
		},
		{
			"xiyaowong/telescope-emoji.nvim",
		},
	},
	opts = {
		pickers = {
			find_files = {
				hidden = true,
				find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
			},
		},
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
		extensions = {
			fzf = {
				fuzzy = false,
				override_generic_sorter = true,
				override_file_sorter = true,
				case_mode = "smart_case",
			},
			live_grep_args = {
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--hidden",
					"--glob",
					"!**/.git/*",
				},
			},
		},
	},
	keys = {
		{ "<leader>ff", require("telescope.builtin").find_files, desc = "Find files" },
		{ "<leader>fb", require("telescope.builtin").buffers, desc = "List buffers" },
		{
			"<leader>fw",
			function()
				local telescope = require("telescope")
				telescope.extensions.live_grep_args.live_grep_args()
			end,
		},
		{
			"<leader>gc",
			function()
				local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")
				live_grep_args_shortcuts.grep_word_under_cursor()
			end,
			desc = "Grep word under cursor",
		},
		{ "<leader>gt", require("telescope.builtin").git_status, desc = "Git status" },
		{ "<leader>fgb", require("telescope.builtin").git_branches, desc = "Git branches" },
		{ "<leader>fgs", require("telescope.builtin").git_stash, desc = "Git stash" },
		{ "<leader>fgc", require("telescope.builtin").git_commits, desc = "Git commits" },
		{ "<leader>fgh", require("telescope.builtin").git_bcommits, desc = "Git bcommits" },
		{ "<leader>fr", require("telescope.builtin").resume, desc = "Resume last telescope" },
		{ "<leader>fo", require("telescope.builtin").oldfiles, desc = "Old files" },
		{ "<leader>fe", ":Telescope emoji<cr>", desc = "Emoji" },
	},
	config = function(_, opts)
		local telescope = require("telescope")
		local lga_actions = require("telescope-live-grep-args.actions")

		-- this is an override to quote prompt with <C-k> using live_grep_args extension
		opts.extensions.live_grep_args.mappings = {
			i = {
				["<C-k>"] = lga_actions.quote_prompt(),
				["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
			},
		}

		OMG = opts

		telescope.setup(opts)
		telescope.load_extension("fzf")
		telescope.load_extension("live_grep_args")
		telescope.load_extension("emoji")
	end,
}
