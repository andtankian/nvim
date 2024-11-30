local utils = require("utils")

return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "xiyaowong/telescope-emoji.nvim" },
			{
				"nvim-telescope/telescope-live-grep-args.nvim",
				version = "^1.0.0",
			},
			{
				"xiyaowong/telescope-emoji.nvim",
			},
			{ "aaronhallaert/advanced-git-search.nvim", cmd = { "AdvancedGitSearch" } },
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
				advanced_git_search = {
					diff_plugin = "diffview",
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
					live_grep_args_shortcuts.grep_visual_selection()
				end,
				desc = "Grep word under cursor",
				mode = "v",
			},
			{ "<leader>gt", require("telescope.builtin").git_status, desc = "Git status" },
			{ "<leader>fgb", require("telescope.builtin").git_branches, desc = "Git branches" },
			{ "<leader>fgs", require("telescope.builtin").git_stash, desc = "Git stash" },
			{ "<leader>fgc", require("telescope.builtin").git_commits, desc = "Git commits" },
			{ "<leader>fgh", require("telescope.builtin").git_bcommits, desc = "Git bcommits" },
			{ "<leader>fr", require("telescope.builtin").resume, desc = "Resume last telescope" },
			{ "<leader>fo", require("telescope.builtin").oldfiles, desc = "Old files" },
			{ "<leader>fe", ":Telescope emoji<cr>", desc = "Emoji" },
			{ "<leader>th", ":Telescope themes<cr>", desc = "Nvchad Themes" },
		},
		config = function(_, opts)
			local telescope = require("telescope")
			local lga_actions = require("telescope-live-grep-args.actions")

			local builtin = require("telescope.builtin")
			local action_state = require("telescope.actions.state")
			local actions = require("telescope.actions")

			Buffer_searcher = function()
				builtin.buffers({
					sort_mru = true,
					ignore_current_buffer = true,
					show_all_buffers = true,
					attach_mappings = function(prompt_bufnr, map)
						local refresh_buffer_searcher = function()
							actions.close(prompt_bufnr)
							vim.schedule(Buffer_searcher)
						end

						local delete_multiple_buf = function()
							local picker = action_state.get_current_picker(prompt_bufnr)
							local selection = picker:get_multi_selection()

							if #selection == 0 then
								local entry = action_state.get_selected_entry()
								if entry then
									vim.api.nvim_buf_delete(entry.bufnr, { force = true })
								end
							else
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

			utils.map("n", "<leader>fb", Buffer_searcher, {
				desc = "List buffers",
			})

			opts.extensions.live_grep_args.mappings = {
				i = {
					["<C-k>"] = lga_actions.quote_prompt(),
					["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
				},
			}

			telescope.setup(opts)
			telescope.load_extension("live_grep_args")
			telescope.load_extension("emoji")
			telescope.load_extension("advanced_git_search")
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			filters = {
				dotfiles = false,
			},
			disable_netrw = true,
			hijack_netrw = true,
			hijack_cursor = true,
			hijack_unnamed_buffer_when_opening = false,
			sync_root_with_cwd = true,
			update_focused_file = {
				enable = true,
				update_root = false,
			},
			view = {
				adaptive_size = true,
				side = "left",
				preserve_window_proportions = true,
				width = {
					max = 60,
				},
			},
			git = {
				enable = true,
				ignore = true,
			},
			filesystem_watchers = {
				enable = true,
			},
			actions = {
				open_file = {
					resize_window = true,
					quit_on_open = false,
				},
			},
			on_attach = function(bufnr)
				local api = require("nvim-tree.api")

				api.config.mappings.default_on_attach(bufnr)
				vim.keymap.del("n", "<C-t>", { buffer = bufnr })
			end,
			renderer = {
				root_folder_label = false,
				highlight_git = true,
				highlight_opened_files = "none",
				indent_markers = {
					enable = true,
				},
				icons = {
					show = {
						file = true,
						folder = true,
						folder_arrow = true,
						git = true,
					},
					glyphs = {
						default = "󰈚",
						symlink = "",
						folder = {
							default = "",
							empty = "",
							empty_open = "",
							open = "",
							symlink = "",
							symlink_open = "",
							arrow_open = "",
							arrow_closed = "",
						},
						git = {
							unstaged = "✗",
							staged = "✓",
							unmerged = "",
							renamed = "➜",
							untracked = "★",
							deleted = "",
							ignored = "◌",
						},
					},
				},
			},
		},
		config = function(_, opts)
			require("nvim-tree").setup(opts)

			utils.map(
				"n",
				"<C-n>",
				"<cmd>NvimTreeToggle<CR>",
				{ desc = "Toggle NvimTree File Explorer", noremap = true, silent = true }
			)
			utils.map(
				"n",
				"<leader>e",
				"<cmd>NvimTreeFocus<CR>",
				{ desc = "Focus NvimTree File Explorer", noremap = true, silent = true }
			)
		end,
	},
}
