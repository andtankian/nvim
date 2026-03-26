return {
	{
		"github/copilot.vim",
		config = function()
			local g = vim.g
			g.copilot_no_tab_map = true
			vim.keymap.set(
				"i",
				"<C-j>",
				'copilot#Accept("<cr>")',
				{ silent = true, expr = true, replace_keycodes = false, desc = "Accept copilot suggestion" }
			)
		end,
	},
	-- {
	-- 	"ravitemer/mcphub.nvim",
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 	},
	-- 	build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
	-- 	opts = {},
	-- },
	-- {
	-- 	"georgeharker/sharedserver",
	-- 	build = "cargo build --release",
	-- 	lazy = false,
	-- },
	--
	-- {
	-- 	"georgeharker/mcp-companion",
	-- 	lazy = false,
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 		"olimorris/codecompanion.nvim",
	-- 		"georgeharker/sharedserver",
	-- 	},
	-- 	build = "cd bridge && uv venv --python 3.14 .venv && uv sync --frozen",
	-- 	config = function()
	-- 		require("mcp_companion").setup({
	-- 			bridge = {
	-- 				port = 9741,
	-- 				config = vim.fn.expand("~/.config/mcp/servers.json"),
	-- 			},
	-- 			log = { level = "info", notify = "error" },
	-- 		})
	-- 	end,
	-- },
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			-- "ravitemer/mcphub.nvim",
			"cairijun/codecompanion-agentskills.nvim",
		},
		opts = {
			interactions = {
				chat = {
					adapter = {
						name = "copilot",
						model = "claude-sonnet-4.6",
					},
				},
			},
			extensions = {
				-- mcphub = {
				-- 	callback = "mcphub.extensions.codecompanion",
				-- 	opts = {
				-- 		make_vars = true,
				-- 		make_slash_commands = true,
				-- 		show_result_in_chat = true,
				-- 	},
				-- },
				-- mcp_companion = {
				-- 	callback = "mcp_companion.cc",
				-- 	opts = {},
				-- },
				agentskills = {
					opts = {
						paths = {
							{ ".claude/skills", recursive = true },
						},
					},
				},
			},
			prompt_library = {
				markdown = {
					dirs = {
						vim.fn.getcwd() .. "/.claude/commands/opsx",
					},
				},
				["Commit and PR"] = {
					interaction = "chat",
					description = "Commit staged changes, push to remote, and create a PR",
					opts = {
						alias = "commit-and-pr",
						auto_submit = false,
					},
					prompts = {
						{
							role = "system",
							content = [[You are an expert Git workflow assistant. Your task is to help with Git operations in a structured manner:

1. First, analyze the staged changes using `git diff --cached`
2. Determine the current branch using `git branch --show-current`
3. Generate a short, kebab-case branch name that describes the changes (e.g. `feat/add-login-page`)
4. Checkout a new branch with that name using `git checkout -b <branch-name>`
5. Generate a meaningful commit message following conventional commits format (feat/fix/docs/etc)
6. Commit the staged changes with the generated message
7. Push the new branch to the remote repository using `git push -u origin <branch-name>`
8. Create a pull request using GitHub CLI (`gh pr create`)

Always confirm actions before executing them and provide clear explanations of what you're doing.]]
						},
						{
							role = "user",
							content = [[@{full_stack_dev} Please help me commit my staged changes and create a PR. Here's what I need:

1. Review my staged changes (use `git diff --cached`)
2. Check the current branch (use `git branch --show-current`)
3. Generate a short, descriptive kebab-case branch name based on the staged changes (e.g. `feat/add-login-page`)
4. Checkout a new branch with that name (use `git checkout -b <branch-name>`)
5. Generate an appropriate commit message based on the changes
6. Commit the changes
7. Push the new branch to remote with tracking (use `git push -u origin <branch-name>`)
8. Create a PR with a descriptive title (do not make the title a conventional commit message, but a meaningful plain english title)
9. If the current project has a pull_request_template.md file, use it to generate the PR description. If not, create a detailed description based on the changes.
10. The pull request description should be written in a temporary markdown file, then used in the gh command to create the PR. After the PR is created, delete the temporary markdown file.]]
						},
					},
				},
			},
		},
		keys = {
			{
				"<leader>cc",
				":CodeCompanionChat Toggle<CR>",
				desc = "Open Code Companion",
			},
		},
	},
}
