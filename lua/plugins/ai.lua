local utils = require("utils")

return {
	{
		"supermaven-inc/supermaven-nvim",
		opts = {
			keymaps = {
				accept_suggestion = "<C-j>",
				clear_suggestion = "<C-]>",
				accept_word = "<C-k>",
			},
		},
	},
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"hrsh7th/nvim-cmp",
			"nvim-telescope/telescope.nvim",
			{ "stevearc/dressing.nvim", opts = {} },
		},
		opts = {
			display = {
				chat = {
					show_header_separator = false,
				},
			},
			strategies = {
				chat = {
					adapter = "anthropic",
					slash_commands = {
						["buffer"] = {
							opts = {
								provider = "telescope",
							},
						},
					},
				},
				inline = {
					adapter = "anthropic",
				},
				agent = {
					adapter = "anthropic",
				},
			},
			prompt_library = {
				["Generate a Commit Message And PR it"] = {
					strategy = "workflow",
					description = "Generate a commit message and submit a PR",
					opts = {
						index = 10,
						is_default = true,
						is_slash_cmd = true,
						short_name = "commit-and-pr",
						auto_submit = false,
					},
					references = {
						{
							type = "file",
							path = {
								".github/pull_request_template.md",
							},
						},
					},
					prompts = {
						{
							{
								role = "user",
								content = function()
									return string.format(
										[[You are an expert at following the Conventional Commit specification. Given the git diff listed below, please generate a commit message for me. It's important to generate a concise header commit message only, without any detailed description and without any specific scope:

      ```diff
      %s
      ```
      ]],
										vim.fn.system("git diff --no-ext-diff --staged")
									)
								end,
								opts = {
									contains_code = true,
									auto_submit = true,
								},
							},
						},
						{
							{
								role = "user",
								content = function()
									return [[Give me the command to create a new PR using gh cli. The body of the PR should be filled up based on the changes in the diff and the provided template. Here more options that should be present in the command:

- base: main
- label: feature
- assignee: @me
- title: My PR title]]
								end,
								opts = {
									contains_code = true,
									auto_submit = false,
								},
							},
						},
					},
				},
			},
		},
		config = function(_, opts)
			require("codecompanion").setup(opts)

			utils.map("n", "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
			utils.map("v", "<leader>cc", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })
			vim.api.nvim_create_user_command("Cc", "CodeCompanion <args>", { nargs = "*" })
		end,
	},
}
