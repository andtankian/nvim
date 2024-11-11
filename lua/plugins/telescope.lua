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

		local builtin = require("telescope.builtin")
		local action_state = require("telescope.actions.state")
		local actions = require("telescope.actions")

		buffer_searcher = function()
			builtin.buffers({
				sort_mru = true,
				ignore_current_buffer = true,
				show_all_buffers = true,
				attach_mappings = function(prompt_bufnr, map)
					local refresh_buffer_searcher = function()
						actions.close(prompt_bufnr)
						vim.schedule(buffer_searcher)
					end

					local delete_multiple_buf = function()
						local picker = action_state.get_current_picker(prompt_bufnr)
						local selection = picker:get_multi_selection()

						if #selection == 0 then
							-- Delete current selection if no multi-selection
							local entry = action_state.get_selected_entry()
							if entry then
								vim.api.nvim_buf_delete(entry.bufnr, { force = true })
							end
						else
							-- Delete all selected buffers
							for _, entry in ipairs(selection) do
								vim.api.nvim_buf_delete(entry.bufnr, { force = true })
							end
						end
						refresh_buffer_searcher()
					end

					map("n", "x", delete_multiple_buf)

					return true
				end,
			})
		end

		utils.map("n", "<leader>fb", buffer_searcher, {
			desc = "List buffers",
		})

		-- this is an override to quote prompt with <C-k> using live_grep_args extension
		opts.extensions.live_grep_args.mappings = {
			i = {
				["<C-k>"] = lga_actions.quote_prompt(),
				["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
			},
		}

		telescope.setup(opts)
		telescope.load_extension("fzf")
		telescope.load_extension("live_grep_args")
		telescope.load_extension("emoji")
	end,
}
