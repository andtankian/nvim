local helpers = require("config.utils.helpers")

return {
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"treesitter",
			"mcphub",
		},
		opts = {
			strategies = {
				chat = {
					adapter = "copilot",
					model = "claude-sonnet-4",
					tools = {
						opts = {
							auto_submit_errors = true,
							auto_submit_success = true,
						},
					},
				},
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
			},
			prompt_library = {
				["Commit concise"] = {
					strategy = "chat",
					description = "Generate a conventional commit message without long description.",
					opts = {
						short_name = "commit-concise",
						auto_submit = true,
					},
					context = {
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
								return string.format(
									[[I want you to use the @{cmd_runner} tool to create a commit using a concise commit message that follows the conventional commit format. Make sure to:
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
							},
						},
					},
				},
				["Commit and PR"] = {
					strategy = "workflow",
					description = "Generate a commit, push the branch and create a PR.",
					opts = {
						short_name = "commit-and-pr",
						adapter = "anthropic",
					},
					context = {
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
									return string.format(
										[[I want you to use the @{cmd_runner} tool to create a commit using the conventional commit format. Make sure to:
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
									auto_submit = true,
								},
							},
						},
						{
							{
								role = "user",
								content = "Checkout to a new branch with a relevant name based on the commit message.",
								opts = {
									contains_code = false,
									auto_submit = true,
								},
							},
						},
						{
							{
								role = "user",
								content = "Push the new created and switched branch to the remote repository using the --set-upstream flag.",
								opts = {
									contains_code = false,
									auto_submit = true,
								},
							},
						},
						{
							{
								role = "user",
								content = [[Create a pull request using GitHub CLI:
- Use the provided diff to fill out the PR body according to the given template.
- Scape correctly the crasis symbol (```) in the body.
- Set the base branch to main.
- Assign an appropriate label from refactoring, feature, fix, or chore, based on the changes.
- Set the assignee to @me.
- Generate a clear, first word capitalized title based on the commit message, but do not use the Conventional Commit format—use a plain descriptive title instead.

Execute these steps precisely and efficiently.]],
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
		keys = {
			{ "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", mode = "n", desc = "Toggle Code Companion" },
			{ "<leader>cc", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "Add to Code Companion" },
		},
		config = function(_, opts)
			require("codecompanion").setup(opts)
			vim.g.codecompanion_auto_tool_mode = true
			vim.api.nvim_create_user_command("Cc", "CodeCompanion <args>", { nargs = "*" })
		end,
	},
	{
		"github/copilot.vim",
		event = "InsertEnter",
		config = function()
			local g = vim.g
			g.copilot_no_tab_map = true
			helpers.keymap(
				"i",
				"<C-j>",
				'copilot#Accept("<cr>")',
				{ silent = true, expr = true, replace_keycodes = false, desc = "Accept copilot suggestion" }
			)
		end,
	},
}
