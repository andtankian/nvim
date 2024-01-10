return {
  "jackMort/ChatGPT.nvim",
  event = "VeryLazy",
  opts = {
    popup_layout = {
      center = {
        width = "90%",
        height = "90%",
      },
    },
    openai_params = {
      max_tokens = 1000,
    },
    openai_edit_params = {
      max_tokens = 1000,
    },
  },
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },

  config = function(_, opts)
    require("chatgpt").setup(opts)

    local keymap = vim.keymap

    keymap.set("n", "<leader>gpt", ":ChatGPT<CR>", { noremap = true, silent = true })
  end,
}
