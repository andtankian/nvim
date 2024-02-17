return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      theme = "dracula",
    },
    sections = {
      lualine_c = {
        require("lsp-progress").progress,
      },
    },
  },
  config = function(_, opts)
    require("lualine").setup(opts)
  end,
}
