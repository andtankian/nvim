return {
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
  { "echasnovski/mini.surround", version = "*", opts = {} },
  { "echasnovski/mini.ai",       version = "*", opts = {} },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },
  {
    "tversteeg/registers.nvim",
    cmd = "Registers",
    config = true,
    keys = {
      { '"',     mode = { "n", "v" } },
      { "<C-R>", mode = "i" },
    },
    name = "registers",
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    opts = {},
  },
  {
    "tpope/vim-abolish",
  },
  {
    "andtankian/nxtest.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      terminal_position = "vertical",
    },
  }
}
