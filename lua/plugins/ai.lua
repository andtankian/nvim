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
		"ravitemer/mcphub.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		cmd = "MCPHub",
		build = "npm install -g mcp-hub@latest",
		config = function()
			require("mcphub").setup({
				extensions = {
					codecompanion = {
						-- Show the mcp tool result in the chat buffer
						show_result_in_chat = true,
						-- Make chat #variables from MCP server resources
						make_vars = true,
						-- Create slash commands for prompts
						make_slash_commands = true,
					},
				},
			})
		end,
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
				reasoning = function()
					return require("codecompanion.adapters").extend("anthropic", {
						schema = {
							model = {
								default = "claude-3-7-sonnet-20250219",
							},
						},
					})
				end,
				anthropic = function()
					return require("codecompanion.adapters").extend("anthropic", {
						schema = {
							model = {
								default = "claude-3-5-sonnet-20241022",
							},
						},
					})
				end,
			},
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
					tools = {
						["mcp"] = {
							-- Prevent mcphub from loading before needed
							callback = function()
								return require("mcphub.extensions.codecompanion")
							end,
							description = "Call tools and resources from the MCP Servers",
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
									[[@cmd_runner

You are an expert in following the Conventional Commit specification. Based on the provided diff, perform the following steps: 
1. Commit the changes using a concise commit message that follows the Conventional Commit format. 
  - Use only a header (no detailed description).
  - Use the provided scope settings file to base your self what scope to use.
  - Ensure the message is clear, relevant, and properly formatted.

Important Notes:
- Do not run git add, as all provided diffs are already staged.

Execute these steps precisely.

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
							},
						},
					},
					prompts = {
						{
							{
								role = "user",
								content = function()
									vim.g.codecompanion_auto_tool_mode = true

									return string.format(
										[[@cmd_runner

You are an expert in following the Conventional Commit specification. Based on the provided diff, perform the following steps: 
1. Create a new branch for the commit.
2. Commit the changes using a concise commit message that follows the Conventional Commit format. 
  - Use only a header (no detailed description or specific scope).
  - Ensure the message is clear, relevant, and properly formatted.
3. Push the branch to the remote repository with –set-upstream origin.

Important Notes:
- Do not run git add, as all provided diffs are already staged.
- Go directly to committing and pushing without modifying the staged files.

Execute these steps precisely.

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
						{
							{
								role = "user",
								content = function()
									return [[You are an expert in creating pull requests using the GitHub CLI. Based on the provided diff and template, generate a new PR with the following specifications:
- Use the provided diff to fill out the PR body according to the given template.
- Set the base branch to main.
- Assign an appropriate label from refactoring, feature, fix, or chore, based on the changes.
- Set the assignee to @me.
- Generate a clear, first word capitalized title based on the commit message, but do not use the Conventional Commit format—use a plain descriptive title instead.

Execute these steps precisely and efficiently.]]
								end,
								opts = {
									contains_code = false,
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
