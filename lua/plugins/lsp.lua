local externals = require("externals")

return {
	{
		"nvimtools/none-ls.nvim",
		config = function()
			local nonels = require("null-ls")

			local builtins = nonels.builtins

			nonels.setup({
				sources = {
					builtins.formatting.prettier.with({
						filetypes = { "javascript", "typescript", "json", "javascriptreact", "typescriptreact" },
					}),
					builtins.formatting.stylua,
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"mason-lspconfig",
			"cmp-lsp",
			{
				"linrongbin16/lsp-progress.nvim",
				config = function()
					require("lsp-progress").setup()
				end,
			},
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

			-- Global mappings.
			vim.keymap.set("n", "<leader>f", vim.diagnostic.open_float)
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next)

			-- Restart lsp server
			vim.keymap.set("n", "<leader>lr", ":LspRestart<CR>", { silent = true, noremap = true })
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					-- Buffer local mappings.
					local opts = { buffer = ev.buf }
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "<leader>fm", function()
						vim.lsp.buf.format({ async = true })
					end, opts)
				end,
			})
		end,
	},
}
