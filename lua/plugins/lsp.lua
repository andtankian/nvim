local externals = require("externals")
local utils = require("utils")

return {
	{
		"stevearc/conform.nvim", -- formatter plugin
		name = "conform",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				json = { "prettier" },
			},
		},
	},
	-- nvim lint not used because for js/ts we have an lsp (eslint-lsp) so we don't need additional linter
	-- {
	-- 	"mfussenegger/nvim-lint",
	-- },
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"mason-lspconfig",
			"cmp-lsp",
			"conform",
		},
		keys = {
			{ "<leader>lr", ":LspRestart<CR>", desc = "Restart LSP", { silent = true, noremap = true } },
			{ "<leader>f", vim.diagnostic.open_float, desc = "Open float with current diagnostic error" },
			{ "[d", vim.diagnostic.goto_prev, desc = "Go to previous diagnostic error" },
			{ "]d", vim.diagnostic.goto_next, desc = "Go to next diagnostic error" },
		},
		config = function()
			local lspconfig = require("lspconfig")

			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}

			for _, lsp in ipairs(externals.lsps) do
				lspconfig[lsp].setup({
					capabilities = capabilities,
				})
			end

			-- eslint specific
			lspconfig.eslint.setup({
				capabilities = capabilities,
				settings = {
					workingDirectory = { mode = "location" },
				},
				root_dir = lspconfig.util.find_git_ancestor,
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					-- Buffer local mappings.
					local opts = { buffer = ev.buf }
					utils.map("n", "gd", vim.lsp.buf.definition, opts)
					utils.map("n", "K", vim.lsp.buf.hover, opts)
					utils.map("n", "<C-k>", vim.lsp.buf.signature_help, opts)
					utils.map("n", "<leader>rn", vim.lsp.buf.rename, opts)
					utils.map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
					utils.map("n", "gr", vim.lsp.buf.references, opts)
					utils.map("n", "<leader>fm", function()
						require("conform").format({ async = true, lsp_fallback = true })
					end, opts)
					utils.map("n", "<leader>fa", function()
						vim.lsp.buf.code_action({
							filter = function(a)
								return a.isPreferred
							end,
							apply = true,
						})
					end)
				end,
			})
		end,
	},
}
