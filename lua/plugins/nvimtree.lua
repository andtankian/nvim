local utils = require("utils")
-- Disable native explorer for faster startup
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

return {
	"nvim-tree/nvim-tree.lua", -- file explorer plugin
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
      }
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
        quit_on_open = true,
			},
		},
		on_attach = function(bufnr)
			local api = require("nvim-tree.api")

			-- default mappings
			api.config.mappings.default_on_attach(bufnr)

			-- custom override mappings ()
			vim.keymap.del("n", "<C-t>", { buffer = bufnr}) -- avoid conflict with toggle terminal launch
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
}
