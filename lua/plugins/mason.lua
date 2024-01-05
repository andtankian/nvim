return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "lua_ls" }
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)
    end
  }
}
