return {
  {
    'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
  },
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local telescope = require("telescope")
      local builtin = telescope.builtin

      local mapping_options = {
        silent = true,
        noremap = true
      }

      local keymap = vim.keymap

      keymap.set("n", "<leader>ff", builtin.find_files, mapping_options)
      keymap.set("n", "<leader>fw", builtin.live_grep, mapping_options)
      keymap.set("n", "<leader>gt", builtin.git_files, mapping_options)

      telescope.load_extension("fzf")
    end

  }}
