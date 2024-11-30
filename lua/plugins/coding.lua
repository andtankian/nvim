local externals = require("externals")
local utils = require("utils")

return {
	{
		"hrsh7th/cmp-nvim-lsp",
		name = "cmp-lsp",
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"cmp-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-u>"] = cmp.mapping.scroll_docs(-4),
					["<C-d>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					}),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = {
					{ name = "nvim_lsp" },
					{ name = "buffer" },
				},
			})
		end,
	},
	{
		"williamboman/mason.nvim",
		name = "mason",
		opts = {},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		name = "mason-lspconfig",
		dependencies = {
			"mason",
		},
		opts = {
			ensure_installed = externals.lsps,
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = {
			ensure_installed = vim.tbl_extend("force", externals.formatters, externals.linters),
		},
		dependencies = {
			"mason",
		},
	},
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

			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
						},
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						telemetry = {
							enable = false,
						},
					},
				},
			})

			for _, lsp in ipairs(externals.lsps) do
				if lsp ~= "lua_ls" then
					lspconfig[lsp].setup({
						capabilities = capabilities,
					})
				end
			end

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
	{
		"stevearc/conform.nvim",
		name = "conform",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				json = { "prettier" },
				yaml = { "yamlfmt" },
				terraform = { "terraform_fmt" },
			},
		},
	},
	{
		"numToStr/Comment.nvim",
		opts = {},
		lazy = false,
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},
	{
		"tpope/vim-abolish",
	},
	{
		"tversteeg/registers.nvim",
		cmd = "Registers",
		config = true,
		keys = {
			{ '"', mode = { "n", "v" } },
			{ "<C-R>", mode = "i" },
		},
		name = "registers",
	},
}