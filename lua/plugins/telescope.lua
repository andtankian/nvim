return {
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local telescope = require("telescope")

      telescope.setup({
        defaults = {
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              width = 0.9,
              prompt_position = "top"
            } 
          },
          path_display = {
            shorten = { len = 3, exclude = { -1, -2, -3, 3, 4 } },
            truncate = 1
          }
        },
        extensions = {
          fzf = {
            fuzzy = false,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case"
          }
        }
      })

      telescope.load_extension("fzf")

      local keymap = vim.keymap
      local builtin = require("telescope.builtin")

      keymap.set("n", "<leader>ff", builtin.find_files, {})
      keymap.set("n", "<leader>fw", builtin.live_grep, {})
      keymap.set("n", "<leader>gt", builtin.git_status, {})

    end

  }
}
