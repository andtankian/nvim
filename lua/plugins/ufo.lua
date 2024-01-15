return {
  "kevinhwang91/nvim-ufo",
  dependencies = { "kevinhwang91/promise-async" },
  name = "ufo",
  config = function()
    require("ufo").setup()
  end,
}
