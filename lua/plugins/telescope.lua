return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
        -- This will not install any breaking changes.
        -- For major updates, this must be adjusted manually.
        version = "^1.0.0",
      },
      {
        "dawsers/telescope-file-history.nvim",
        config = function()
          require("file_history").setup({
            backup_dir = "~/.file-history-git",
            git_cmd = "git",
          })
        end,
      },
      "aaronhallaert/advanced-git-search.nvim",
    },
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
      telescope.load_extension("live_grep_args")
      telescope.load_extension("file_history")
      telescope.load_extension("advanced_git_search")

      local keymap = vim.keymap
      local builtin = require("telescope.builtin")
      local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")

      keymap.set("n", "<leader>ff", builtin.find_files, {})
      keymap.set("n", "<leader>fb", builtin.buffers, {})
      keymap.set("n", "<leader>fw", telescope.extensions.live_grep_args.live_grep_args, {})
      keymap.set("n", "<leader>gt", builtin.git_status, {})
      keymap.set("n", "<leader>fgb", builtin.git_branches, {})
      keymap.set("n", "<leader>fgs", builtin.git_stash, {})
      keymap.set("n", "<leader>fgc", builtin.git_commits, {})
      keymap.set("n", "<leader>gc", live_grep_args_shortcuts.grep_word_under_cursor, {})
      keymap.set("n", "<leader>fr", builtin.resume, {})
      keymap.set("n", "<leader>fh", ":Telescope advanced_git_search search_log_content_file<cr>", {})
    end,
  },
}
