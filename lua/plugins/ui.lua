return {
  -- Lualine statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
      -- Custom component to show active LSP clients
      local function lsp_clients()
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        if #clients == 0 then
          return ""
        end

        local client_names = {}
        for _, client in pairs(clients) do
          table.insert(client_names, client.name)
        end
        return table.concat(client_names, ", ")
      end

      require("lualine").setup({
        options = {
          theme = "catppuccin",
          globalstatus = true, -- Single statusline for all windows
          disabled_filetypes = {
            statusline = { "dashboard", "alpha", "starter" },
          },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 } }, -- 1 = relative path
          lualine_x = { lsp_clients, "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },
}
