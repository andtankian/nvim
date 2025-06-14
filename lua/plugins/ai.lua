local utils = require("utils")

return {
	{
		"github/copilot.vim",
		config = function()
			local g = vim.g
			g.copilot_no_tab_map = true
			utils.map(
				"i",
				"<C-j>",
				'copilot#Accept("<cr>")',
				{ noremap = true, silent = true, expr = true, replace_keycodes = false, desc = "Accept copilot suggestion" }
			)
		end,
	},
	{
		"ravitemer/mcphub.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		cmd = "MCPHub",
		build = "npm install -g mcp-hub@latest",
		opts = {},
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
			adapters = {
				copilot = function()
					return require("codecompanion.adapters").extend("copilot", {
						schema = {
							model = {
								default = "claude-sonnet-4",
							},
						},
					})
				end,
			},
			extensions = {
				mcphub = {
					callback = "mcphub.extensions.codecompanion",
					opts = {
						show_result_in_chat = true,
						make_vars = true,
						make_slash_commands = true,
					},
				},
				vectorcode = {
					opts = { add_tool = true, add_slash_command = true, tool_opts = {} },
				},
			},
			display = {
				chat = {
					show_header_separator = false,
				},
			},
			strategies = {
				chat = {
					adapter = "copilot",
					slash_commands = {
						["buffer"] = {
							opts = {
								provider = "telescope",
							},
						},
					},
				},
				inline = {
					adapter = "copilot",
				},
				agent = {
					adapter = "copilot",
				},
			},
			prompt_library = {
				["Commit concise"] = {
					strategy = "chat",
					description = "Generate a conventional commit message without long description.",
					opts = {
						index = 11,
						is_default = true,
						short_name = "commit-concise",
						auto_submit = true,
					},
					references = {
						{
							type = "file",
							path = {
								".vscode/settings.json",
							},
						},
					},
					prompts = {
						{
							role = "user",
							content = function()
								vim.g.codecompanion_auto_tool_mode = true

								return string.format(
									[[I want you to use the @cmd_runner tool to create a commit using a concise commit message that follows the conventional commit format. Make sure to:
1. Use only a header (no detailed description).
2. Choose the correct scope based on the changes.
3. Ensure the message is clear, relevant, and properly formatted.
4. DO NOT run git add, as all the changes is provided and already staged.

Here is the diff:

```diff
%s
```]],
									vim.fn.system("git diff --no-ext-diff --staged")
								)
							end,
							opts = {
								contains_code = true,
								auto_submit = true,
							},
						},
					},
				},
				["Commit and PR"] = {
					strategy = "workflow",
					description = "Generate a commit, push the branch and create a PR.",
					opts = {
						index = 10,
						is_default = true,
						short_name = "commit-and-pr",
						auto_submit = false,
					},
					references = {
						{
							type = "file",
							path = {
								".github/pull_request_template.md",
								".vscode/settings.json",
							},
						},
					},
					prompts = {
						{
							{
								role = "system",
								content = [[You are an expert creating commits using the conventional commit format. You know exactly how to generate a commit message based on any provided diff. You're also an expert in creating pull requests using the GitHub CLI.]],
								opts = {
									visible = false,
								},
							},
							{
								role = "user",
								content = function()
									vim.g.codecompanion_auto_tool_mode = true

									return string.format(
										[[I want you to use the @cmd_runner tool to create a commit using the conventional commit format. Make sure to:
1. Use the provided diff to generate a commit message.
2. Write only the header (no detailed description and no scope).
3. Ensure the message is clear, relevant, and properly formatted.
4. DO NOT run git add, as all the changes is provided and already staged.

Here is the diff:

```diff
%s
```]],
										vim.fn.system("git diff --no-ext-diff --staged")
									)
								end,
								opts = {
									contains_code = true,
									auto_submit = false,
								},
							},
						},
						{
							{
								role = "user",
								content = "I want you to use the @cmd_runner tool again, but this time you will checkout to a new branch with a relevant name based on the commit message.",
								opts = {
									contains_code = false,
									auto_submit = false,
								},
							},
						},
						{
							{
								role = "user",
								content = "I want you to use the @cmd_runner tool again, but this time you will push the new created and switched branch to the remote repository using the --set-upstream flag.",
								opts = {
									contains_code = false,
									auto_submit = false,
								},
							},
						},
						{
							{
								role = "user",
								content = [[I want you to NOT run any command in this request, just output it for me. Create a pull request using GitHub CLI, generate a new PR with the following specifications:
- Use the provided diff to fill out the PR body according to the given template.
- Scape correctly the crasis symbol (```) in the body.
- Set the base branch to main.
- Assign an appropriate label from refactoring, feature, fix, or chore, based on the changes.
- Set the assignee to @me.
- Generate a clear, first word capitalized title based on the commit message, but do not use the Conventional Commit format—use a plain descriptive title instead.]],
								opts = {
									contains_code = true,
									auto_submit = false,
								},
							},
						},
						{
							{
								role = "user",
								content = [[Now, finally, I want you use @cmd_runner tool this time to create a pull request using GitHub CLI based on the following command:

                ```bash

                ```]],
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
	{
		"Davidyz/VectorCode",
		version = "*",
		build = "pipx upgrade vectorcode", -- recommended if you set `version = "*"` or follow the main branch
		dependencies = { "nvim-lua/plenary.nvim" },
	},
}
