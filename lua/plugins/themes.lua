return {
  -- Catppuccin colorscheme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000, -- Load before other plugins
    lazy = false, -- Load immediately on startup
    config = function()
      require("catppuccin").setup({
        flavour = "macchiato", -- latte, frappe, macchiato, mocha
        background = {
          light = "latte",
          dark = "mocha",
        },
        transparent_background = false,
        show_end_of_buffer = false,
        term_colors = true,
        dim_inactive = {
          enabled = false,
          shade = "dark",
          percentage = 0.15,
        },
        no_italic = false,
        no_bold = false,
        no_underline = false,
        styles = {
          comments = { "italic" },
          conditionals = { "italic" },
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
        },
        color_overrides = {},
        custom_highlights = function(colors)
          return {
            -- Telescope: lighter background for prompt (input area)
            TelescopePromptNormal = { bg = colors.surface0 },
            TelescopePromptBorder = { bg = colors.surface0, fg = colors.surface0 },
            TelescopePromptTitle = { bg = colors.blue, fg = colors.mantle, bold = true },

            -- Results: darkest background
            TelescopeResultsNormal = { bg = colors.mantle },
            TelescopeResultsBorder = { bg = colors.mantle, fg = colors.mantle },
            TelescopeResultsTitle = { bg = colors.mauve, fg = colors.mantle, bold = true },

            -- Preview: darker background (but lighter than results)
            TelescopePreviewNormal = { bg = colors.base },
            TelescopePreviewBorder = { bg = colors.base, fg = colors.base },
            TelescopePreviewTitle = { bg = colors.green, fg = colors.mantle, bold = true },

            -- Render-markdown: Headings with Catppuccin colors
            RenderMarkdownH1 = { fg = colors.red, bold = true },
            RenderMarkdownH1Bg = { bg = colors.surface0 },
            RenderMarkdownH2 = { fg = colors.peach, bold = true },
            RenderMarkdownH2Bg = { bg = colors.surface0 },
            RenderMarkdownH3 = { fg = colors.yellow, bold = true },
            RenderMarkdownH3Bg = { bg = colors.surface0 },
            RenderMarkdownH4 = { fg = colors.green, bold = true },
            RenderMarkdownH4Bg = { bg = colors.surface0 },
            RenderMarkdownH5 = { fg = colors.blue, bold = true },
            RenderMarkdownH5Bg = { bg = colors.surface0 },
            RenderMarkdownH6 = { fg = colors.mauve, bold = true },
            RenderMarkdownH6Bg = { bg = colors.surface0 },

            -- Render-markdown: Code blocks
            RenderMarkdownCode = { bg = colors.surface0 },
            RenderMarkdownCodeInline = { bg = colors.surface0, fg = colors.flamingo },

            -- Render-markdown: Callouts/alerts
            RenderMarkdownInfo = { fg = colors.blue },
            RenderMarkdownSuccess = { fg = colors.green },
            RenderMarkdownHint = { fg = colors.teal },
            RenderMarkdownWarn = { fg = colors.yellow },
            RenderMarkdownError = { fg = colors.red },

            -- Command line: Match lualine background
            MsgArea = { bg = colors.mantle },
          }
        end,
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          notify = false,
          mini = {
            enabled = true,
            indentscope_color = "",
          },
        },
      })

      -- Set the colorscheme
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- TokyoNight colorscheme (alternative)
  -- Uncomment to use instead of Catppuccin
  --[[
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      require("tokyonight").setup({
        style = "night", -- storm, moon, night, day
        light_style = "day",
        transparent = false,
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
          functions = {},
          variables = {},
          sidebars = "dark",
          floats = "dark",
        },
        sidebars = { "qf", "help", "terminal" },
        day_brightness = 0.3,
        hide_inactive_statusline = false,
        dim_inactive = false,
        lualine_bold = false,
      })

      vim.cmd.colorscheme("tokyonight")
    end,
  },
  --]]
}
