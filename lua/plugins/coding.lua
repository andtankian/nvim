local externals = require("externals")
local utils = require("utils")

return {
	{
		"esmuellert/nvim-eslint",
		opts = {
			settings = {
				format = false,
				useFlatConfig = true,
				experimental = { useFlatConfig = false },
			},
		},
	},
	{
		"saghen/blink.cmp",
		dependencies = "rafamadriz/friendly-snippets",
		version = "*",
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			enabled = function()
				return not vim.tbl_contains({ "DressingInput" }, vim.bo.filetype)
			end,
			cmdline = { enabled = false },
			signature = { enabled = false },
			keymap = {
				preset = "default",
				["<Tab>"] = { "select_next", "fallback" },
				["<S-Tab>"] = { "select_prev", "fallback" },
				["<Cr>"] = { "accept", "fallback" },
			},
			completion = {
				documentation = {
					auto_show = true,
				},
			},
			appearance = {
				use_nvim_cmp_as_default = true,
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
		},
		opts_extend = { "sources.default" },
	},
	{
		"mason-org/mason.nvim",
		name = "mason",
		opts = {},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		name = "mason-lspconfig",
		dependencies = {
			"mason",
			"neovim/nvim-lspconfig",
		},
		opts = {
			ensure_installed = externals.lsps,
			automatic_enable = false,
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
		dependencies = { "saghen/blink.cmp" },
		keys = {
			{ "<leader>lr", ":LspRestart<CR>", desc = "Restart LSP", { silent = true, noremap = true } },
			{ "<leader>f", vim.diagnostic.open_float, desc = "Open float with current diagnostic error" },
			{
				"[d",
				function()
					vim.diagnostic.jump({ count = -1, float = true })
				end,
				desc = "Go to previous diagnostic error",
			},
			{
				"]d",
				function()
					vim.diagnostic.jump({ count = 1, float = true })
				end,
				desc = "Go to next diagnostic error",
			},
		},
		config = function()
			local lspconfig = require("lspconfig")

			local capabilities = require("blink.cmp").get_lsp_capabilities()

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
					-- utils.map("n", "gi", vim.lsp.buf.implementation, opts)
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
		"antosha417/nvim-lsp-file-operations",
		dependencies = {
			"nvim-lua/plenary.nvim",
			-- Uncomment whichever supported plugin(s) you use
			"nvim-tree/nvim-tree.lua",
			-- "nvim-neo-tree/neo-tree.nvim",
			-- "simonmclean/triptych.nvim"
		},
		opts = {},
	},
	{
		"stevearc/conform.nvim",
		name = "conform",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				json = { "prettier" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
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
