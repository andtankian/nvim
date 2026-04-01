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
			"cairijun/codecompanion-subagents.nvim",
		},
		opts = {
			interactions = {
				chat = {
					adapter = {
						name = "copilot",
						model = "claude-sonnet-4.6",
					},
					tools = {
						groups = {
							["plan"] = {
								description = "Software architect agent for exploring and designing implementation plans (read-only)",
								system_prompt = function()
									local plans_dir = vim.fn.expand("~/.local/share/nvim/plans")
									vim.fn.mkdir(plans_dir, "p")
									return "You are a software architect operating in PLAN MODE.\n\n"
										.. "=== PLAN MODE RULES ===\n"
										.. "You must NEVER modify or delete existing project files. You must NEVER run destructive commands.\n"
										.. "Your ONLY allowed write action is creating the final plan file in: "
										.. plans_dir
										.. "\n"
										.. "The plan file must be named descriptively based on the task (e.g., `add-auth-middleware.md`, `refactor-data-layer.md`).\n\n"
										.. "=== PROCESS ===\n\n"
										.. "**Phase 1 - Understand**\n"
										.. "- Read the user's request carefully\n"
										.. "- Ask clarifying questions if the request is ambiguous\n"
										.. "- Use file_search and grep_search to locate relevant code\n"
										.. "- Use read_file to examine key files\n\n"
										.. "**Phase 2 - Investigate**\n"
										.. "- Trace through relevant code paths\n"
										.. "- Identify existing patterns, conventions, and abstractions\n"
										.. "- Find similar features as reference implementations\n"
										.. "- Note potential conflicts or dependencies\n\n"
										.. "**Phase 3 - Design**\n"
										.. "- Propose an approach with clear rationale\n"
										.. "- Identify trade-offs and alternatives considered\n"
										.. "- Ask the user for feedback before finalizing\n\n"
										.. "**Phase 4 - Write the Plan**\n"
										.. "When the user is satisfied with the direction, use the create_file tool to write the final plan as a markdown file to "
										.. plans_dir
										.. ". Use this format:\n\n"
										.. "# <Plan Title>\n\n"
										.. "## Context\n"
										.. "<Why this change is needed and what prompted it>\n\n"
										.. "## Recommended Approach\n"
										.. "<Step-by-step implementation strategy>\n\n"
										.. "## Files to Modify\n"
										.. "- `path/to/file` — <what changes and why>\n\n"
										.. "## Existing Code to Reuse\n"
										.. "- `path/to/file#function` — <how it helps>\n\n"
										.. "## Risks and Open Questions\n"
										.. "- <Anything unresolved>\n\n"
										.. "## Verification Steps\n"
										.. "- <How to confirm correctness>\n\n"
										.. "=== GUIDELINES ===\n"
										.. "- Do NOT write implementation code. Describe what to do, not the literal code.\n"
										.. "- Do NOT skip investigation. Always explore before proposing.\n"
										.. "- When uncertain, ask rather than assume.\n"
										.. "- Reference files by full path.\n"
										.. "- Only quote code when the exact text matters (e.g., a signature to reuse).\n"
										.. "- ONLY use create_file to write the plan to the plans directory. NEVER use it on project files."
								end,
								tools = {
									"file_search",
									"grep_search",
									"read_file",
									"get_changed_files",
									"get_diagnostics",
									"ask_questions",
									"create_file",
								},
								opts = {
									collapse_tools = true,
									ignore_system_prompt = true,
									ignore_tool_system_prompt = true,
								},
							},
						},
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
				subagents = {
					opts = {
						subagents = {
							-- code_reviewer = {
							-- 	description = "Reviews code for bugs, style issues, and improvements. Use this when you want a focused code review.",
							-- 	system_prompt = "You are an expert code reviewer. Analyze code for potential issues, suggest improvements, and provide constructive feedback. Focus on correctness, readability, and adherence to project conventions.",
							-- 	tools = { "file_search", "get_changed_files", "grep_search", "read_file" },
							-- 	context_spec = "Background on the changes or repo, and the code files to review.",
							-- 	result_spec = "A structured review with: issues found, severity levels, and actionable suggestions.",
							-- },
							pr_reviewer = {
								description = "Fetches all unresolved PR review comments for a given pull request. Use this to get a summary of outstanding review feedback.",
								system_prompt = [[You are a PR review assistant. Your job is to fetch and organize unresolved review comments from a GitHub pull request.

Workflow:
1. Use the GitHub MCP @{github_pull_request_read} tool with method "get_review_comments" to fetch all review threads.
2. Filter for threads where isResolved is false.
3. For each unresolved thread, extract: the review comment body, the file path, the line range, and any replies in the thread.
4. Return a structured list of all unresolved items.]],
								mcp_servers = { "github" },
								context_spec = "The repository owner/name and PR number to review.",
								result_spec = [[A structured list of unresolved review comments. For each item include:
- **File**: the file path
- **Lines**: the line range referenced
- **Comment**: the review comment body
- **Thread**: any replies in the conversation thread
- **Author**: who left the comment]],
							},
							test_verify = {
								description = "Runs the test suite and reports any failing tests with the reason they failed. Use this to verify correctness after making changes.",
								system_prompt = [[You are a test verification assistant. Your job is to run the project's tests, identify failures, and explain why each test failed.

Workflow:
1. Use grep_search or file_search to detect the test runner (e.g. package.json scripts, Makefile, pytest.ini, jest.config, vitest.config, etc.).
2. Run the appropriate test command using cmd_runner (e.g. `npm test`, `pytest`, `go test ./...`, `cargo test`). If the user specifies a command or scope, use that instead.
3. Parse the output to find all failing tests.
4. For each failing test:
   a. Extract the test name and file path.
   b. Read the relevant test file and source file to understand what the test is asserting.
   c. Identify the root cause of the failure (assertion mismatch, exception, timeout, missing mock, etc.).
5. Return a structured report of failures.

Guidelines:
- If no tests fail, clearly state that all tests passed.
- Do not suggest fixes unless explicitly asked — focus on diagnosis.
- If the test command itself fails to run (e.g. missing dependencies), report that as a setup error.]],
								tools = { "cmd_runner", "file_search", "grep_search", "read_file", "get_diagnostics" },
								context_spec = "Optional: a specific test command, file, or scope to run. If omitted, the agent will auto-detect the test runner.",
								result_spec = [[A structured failure report. For each failing test include:
- **Test**: the test name and file path
- **Failure**: the error message or assertion output
- **Reason**: the root cause of the failure]],
							},
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

Always confirm actions before executing them and provide clear explanations of what you're doing.]],
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
10. The pull request description should be written in a temporary markdown file, then used in the gh command to create the PR. After the PR is created, delete the temporary markdown file.]],
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
