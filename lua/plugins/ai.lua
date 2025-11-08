local helpers = require("config.utils.helpers")

---@param params table Table containing message and allowed_words
---@return table The filtered message
local function filter_out_messages(params)
	local message = params.message

	local allowed = params.allowed_words

	for key, _ in pairs(message) do
		if not vim.tbl_contains(allowed, key) then
			message[key] = nil
		end
	end
	return message
end

return {
	{
		"Davidyz/VectorCode",
		version = "*",
		build = "uv tool upgrade vectorcode", -- This helps keeping the CLI up-to-date
		-- build = "pipx upgrade vectorcode", -- If you used pipx to install the CLI
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim",
			"ravitemer/mcphub.nvim",
			"ravitemer/codecompanion-history.nvim",
			"Davidyz/VectorCode",
		},
		-- dir = "~/dev/codecompanion.nvim",
		-- dev = true,
		opts = function()
			return {
				opts = {
					log_level = "DEBUG",
				},
				adapters = {
					http = {
						copilot = function()
							return require("codecompanion.adapters").extend("copilot", {
								schema = {
									model = {
										default = "claude-sonnet-4.5",
									},
								},
							})
						end,
						anthropic_with_bearer_token = function()
							local utils = require("codecompanion.utils.adapters")
							local tokens = require("codecompanion.utils.tokens")

							return require("codecompanion.adapters").extend("anthropic", {
								env = {
									bearer_token = "ANTHROPIC_BEARER_TOKEN",
								},
								headers = {
									["content-type"] = "application/json",
									["authorization"] = "Bearer ${bearer_token}",
									["anthropic-version"] = "2023-06-01",
									["anthropic-beta"] = "claude-code-20250219,oauth-2025-04-20,interleaved-thinking-2025-05-14,fine-grained-tool-streaming-2025-05-14",
								},
								handlers = {
									setup = function(self)
										-- Same as current setup function but removing the additional headers being added

										if self.opts and self.opts.stream then
											self.parameters.stream = true
										end

										local model = self.schema.model.default
										local model_opts = self.schema.model.choices[model]
										if model_opts and model_opts.opts then
											self.opts = vim.tbl_deep_extend("force", self.opts, model_opts.opts)
											if not model_opts.opts.has_vision then
												self.opts.vision = false
											end
										end

										return true
									end,

									form_messages = function(self, messages)
										-- Same as current form_message but adding Claude Code system message at the first system message

										local has_tools = false

										local system = vim
											.iter(messages)
											:filter(function(msg)
												return msg.role == "system"
											end)
											:map(function(msg)
												return {
													type = "text",
													text = msg.content,
													cache_control = nil,
												}
											end)
											:totable()

										-- Add the Claude Code system message at the beginning (required to make it work)
										table.insert(system, 1, {
											type = "text",
											text = "You are Claude Code, Anthropic's official CLI for Claude.",
											cache_control = {
												type = "ephemeral",
											},
										})

										system = next(system) and system or nil

										messages = vim
											.iter(messages)
											:filter(function(msg)
												return msg.role ~= "system"
											end)
											:totable()

										messages = vim.tbl_map(function(message)
											if message.opts and message.opts.tag == "image" and message.opts.mimetype then
												if self.opts and self.opts.vision then
													message.content = {
														{
															type = "image",
															source = {
																type = "base64",
																media_type = message.opts.mimetype,
																data = message.content,
															},
														},
													}
												else
													return nil
												end
											end

											message = filter_out_messages({
												message = message,
												allowed_words = { "content", "role", "reasoning", "tool_calls" },
											})

											if message.role == self.roles.user or message.role == self.roles.llm then
												if message.role == self.roles.user and message.content == "" then
													message.content = "<prompt></prompt>"
												end

												if type(message.content) == "string" then
													message.content = {
														{ type = "text", text = message.content },
													}
												end
											end

											if message.tool_calls and vim.tbl_count(message.tool_calls) > 0 then
												has_tools = true
											end

											if message.role == "tool" then
												message.role = self.roles.user
											end

											if has_tools and message.role == self.roles.llm and message.tool_calls then
												message.content = message.content or {}
												for _, call in ipairs(message.tool_calls) do
													table.insert(message.content, {
														type = "tool_use",
														id = call.id,
														name = call["function"].name,
														input = vim.json.decode(call["function"].arguments),
													})
												end
												message.tool_calls = nil
											end

											if message.reasoning and type(message.content) == "table" then
												table.insert(message.content, 1, {
													type = "thinking",
													thinking = message.reasoning.content,
													signature = message.reasoning._data.signature,
												})
											end

											return message
										end, messages)

										messages = utils.merge_messages(messages)

										if has_tools then
											for _, m in ipairs(messages) do
												if m.role == self.roles.user and m.content and m.content ~= "" then
													if type(m.content) == "table" and m.content.type then
														m.content = { m.content }
													end

													if type(m.content) == "table" and vim.islist(m.content) then
														local consolidated = {}
														for _, block in ipairs(m.content) do
															if block.type == "tool_result" then
																local prev = consolidated[#consolidated]
																if prev and prev.type == "tool_result" and prev.tool_use_id == block.tool_use_id then
																	prev.content = prev.content .. block.content
																else
																	table.insert(consolidated, block)
																end
															else
																table.insert(consolidated, block)
															end
														end
														m.content = consolidated
													end
												end
											end
										end

										local breakpoints_used = 0
										for i = #messages, 1, -1 do
											local msgs = messages[i]
											if msgs.role == self.roles.user then
												for _, msg in ipairs(msgs.content) do
													if msg.type ~= "text" or msg.text == "" then
														goto continue
													end
													if
														tokens.calculate(msg.text) >= self.opts.cache_over
														and breakpoints_used < self.opts.cache_breakpoints
													then
														msg.cache_control = { type = "ephemeral" }
														breakpoints_used = breakpoints_used + 1
													end
													::continue::
												end
											end
										end
										if system and breakpoints_used < self.opts.cache_breakpoints then
											for _, prompt in ipairs(system) do
												if breakpoints_used < self.opts.cache_breakpoints then
													prompt.cache_control = { type = "ephemeral" }
													breakpoints_used = breakpoints_used + 1
												end
											end
										end

										return { system = system, messages = messages }
									end,
								},
							})
						end,
					},
				},
				strategies = {
					chat = {
						adapter = "copilot",
						tools = {
							opts = {
								auto_submit_errors = true,
								auto_submit_success = true,
								default_tools = {
									"full_stack_dev",
								},
							},
						},
					},
				},
				memory = {
					opts = {
						chat = {
							enabled = true,
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
					history = {
						enabled = true,
						opts = {
							picker = "telescope",
							auto_generate_title = false,
							continue_last_chat = false,
							auto_save = false,
						},
					},
					vectorcode = {
						opts = {
							tool_group = {
								enabled = true,
								extras = {},
								collapse = false,
							},
							tool_opts = {
								["*"] = {},
								ls = {},
								vectorise = {},
								query = {
									max_num = { chunk = -1, document = -1 },
									default_num = { chunk = 50, document = 10 },
									include_stderr = false,
									use_lsp = false,
									no_duplicate = true,
									chunk_mode = false,
									summarise = {
										enabled = false,
										adapter = nil,
										query_augmented = true,
									},
								},
								files_ls = {},
								files_rm = {},
							},
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
							adapter = {
								name = "copilot",
								model = "gpt-4.1",
							},
						},
						context = {
							{
								type = "file",
								path = {
									"/Users/andrewribeiro/.claude/commands/commit.md",
									".vscode/settings.json",
								},
							},
						},
						prompts = {
							{
								role = "user",
								content = [[I want you to commit the staged changes using a concise commit message that follows the conventional commit format. Make sure to:
1. Use only a header (no detailed description).
2. Choose the correct scope based on the changes.
3. Ensure the message is clear, relevant, and properly formatted.
4. DO NOT run git add, as all the changes is provided and already staged.]],
								opts = {
									contains_code = false,
								},
							},
						},
					},
					["Commit and PR"] = {
						strategy = "chat",
						description = "Generate a commit, push the branch and create a PR.",
						opts = {
							short_name = "commit-and-pr",
							adapter = {
								name = "deepseek",
								model = "deepseek-chat",
							},
						},
						context = {
							{
								type = "file",
								path = {
									"/Users/andrewribeiro/.claude/commands/commit.md",
									"/Users/andrewribeiro/.claude/commands/pr.md",
									".github/pull_request_template.md",
									".vscode/settings.json",
								},
							},
						},
						prompts = {
							{
								role = "user",
								content = [[I want you to:
1. Create a new branch regarding the current staged file(s) summary
  - It's important to consider only the staged files. Do not add any unstaged files. Do not add new files to the stage.
2. Commit the staged changes using a concise commit message that follows the conventional commit format
3. Push the new created branch to the remote repository using the --set-upstream flag.
4. Create a pull request using GitHub CLI:
  - Use the provided diff to fill out the PR body according to the given template
  - Save the filled up PR description in a file `tmp/pr_body.md`
  - Set the base branch to main
  - Assign an appropriate label retrieved by `gh label list` command
  - Set the assignee to @me
  - Generate a clear, first word capitalized title based on the commit message, but do not use the Conventional Commit format—use a plain descriptive title instead
  - Execute the gh command considering the previous steps (including the tmp/pr_body.md file)
5. Delete the temporary file `tmp/pr_body.md` after creating the PR.]],
								opts = {
									contains_code = false,
								},
							},
						},
					},
				},
			}
		end,
		keys = {
			{ "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", mode = "n", desc = "Toggle Code Companion" },
			{ "<leader>cc", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "Add to Code Companion" },
		},
		cmd = { "CodeCompanion", "CodeCompanionChat" },
		init = function()
			vim.g.codecompanion_yolo_mode = true
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
	{
		"ravitemer/mcphub.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		build = "npm install -g mcp-hub@latest",
		config = true,
	},
}
