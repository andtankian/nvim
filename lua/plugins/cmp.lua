return {
  {
    "hrsh7th/nvim-cmp",
    name = "cmp"
  },
  {
    "hrsh7th/cmp-nvim-lsp",
    name = "cmp-lsp",
    dependencies = {
      "cmp",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip"
    }
  }
}
