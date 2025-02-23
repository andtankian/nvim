local externals = require("externals")
local utils = require("utils")

return {
	{ "esmuellert/nvim-eslint", opts = {} },
	{
		"saghen/blink.cmp",
		dependencies = "rafamadriz/friendly-snippets",
		version = "*",
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			cmdline = { enabled = false },
			signature = { enabled = true },
			-- 'default' for mappings similar to built-in completion
			-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
			-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
			-- See the full "keymap" documentation for information on defining your own keymap.
			keymap = {
				preset = "default",
				["<Tab>"] = { "select_next", "fallback" },
				["<S-Tab>"] = { "select_prev", "fallback" },
				["<Cr>"] = { "accept", "fallback" },
			},

			appearance = {
				-- Sets the fallback highlight groups to nvim-cmp's highlight groups
				-- Useful for when your theme doesn't support blink.cmp
				-- Will be removed in a future release
				use_nvim_cmp_as_default = true,
				-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
			},

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
		},
		opts_extend = { "sources.default" },
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
		dependencies = { "saghen/blink.cmp" },
		keys = {
			{ "<leader>lr", ":LspRestart<CR>", desc = "Restart LSP", { silent = true, noremap = true } },
			{ "<leader>f", vim.diagnostic.open_float, desc = "Open float with current diagnostic error" },
			{ "[d", vim.diagnostic.goto_prev, desc = "Go to previous diagnostic error" },
			{ "]d", vim.diagnostic.goto_next, desc = "Go to next diagnostic error" },
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
