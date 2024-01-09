return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  opts = function()
    return {
      sources = {
        "filesystem",
      },
      use_popups_for_input = false, -- If false, inputs will use vim.ui.input() instead of custom floats.
      event_handlers = {
        {
          event = "file_opened",
          handler = function()
            require("neo-tree.command").execute({ action = "close" })
          end
        },
        {
          event = "neo_tree_window_after_open",
          handler = function()
            vim.cmd("setlocal rnu")
          end
        }
      },
      default_component_configs = {
        -- If you don't want to use these columns, you can set `enabled = false` for each of them individually
        file_size = {
          enabled = false,
        },
        type = {
          enabled = false,
        },
        last_modified = {
          enabled = false,
        },
        created = {
          enabled = false,
        },
        symlink_target = {
          enabled = false,
        },
      },
      window = {
        auto_expand_width = true,
      },
      filesystem = {
        window = {
          mappings = {
            ["<Tab>"] = {
              "toggle_node",
              nowait = false,
            },
            ["I"] = "toggle_hidden",
            ["[c"] = "prev_git_modified",
            ["]c"] = "next_git_modified",
            ["i"] = "show_file_details",
          },
        },
        filtered_items = {
          visible = false,
          show_hidden_count = true, -- when true, the number of hidden items in each folder will be shown as the last entry
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
    }
  end,
  config = function(_, opts)
    require("neo-tree").setup(opts)

    local mapping_options = {
      noremap = true,
      silent = true,
    }

    vim.keymap.set(
      "n",
      "<C-n>",
      ":Neotree position=left toggle=true source=filesystem reveal_force_cwd=true<CR>",
      mapping_options
    )
    vim.keymap.set(
      "n",
      "<leader>e",
      ":Neotree position=left source=filesystem reveal_force_cwd=true<CR>",
      mapping_options
    )
  end,
}
