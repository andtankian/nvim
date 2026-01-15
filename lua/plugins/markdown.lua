return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ft = { "markdown", "codecompanion" },
    opts = {
      -- Only non-default options
      code = {
        left_pad = 2,
        right_pad = 2,
        width = "block",
        border = "thin",
      },
    },
  },
}
