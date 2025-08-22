local helpers = require("config.utils.helpers")

local js_based_languages = {
	"typescript",
	"javascript",
}

return {
	{
		"saghen/blink.cmp",
		dependencies = "rafamadriz/friendly-snippets",
		event = "InsertEnter",
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
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
		},
		opts_extend = { "sources.default" },
	},
	{
		"antosha417/nvim-lsp-file-operations",
		ft = "NvimTree",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-tree.lua",
		},
		config = true,
	},
	{
		"esmuellert/nvim-eslint",
		ft = js_based_languages,
		opts = {
			settings = {
				format = false,
				useFlatConfig = true,
				experimental = { useFlatConfig = false },
			},
		},
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				json = { "prettier" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				yaml = { "yamlfmt" },
				terraform = { "terraform_fmt" },
				python = { "black" },
			},
		},
		keys = {
			{
				"<leader>fm",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				desc = "Format file",
			},
		},
	},
	{
		"mfussenegger/nvim-dap",
    ft = js_based_languages,
		config = function()
			local dap = require("dap")

			vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

			for _, language in ipairs(js_based_languages) do
				dap.configurations[language] = {
					{
						type = "pwa-node",
						request = "attach",
						name = "Attach",
						processId = require("dap.utils").pick_process,
						cwd = vim.fn.getcwd(),
						sourceMaps = true,
					},
				}
			end
		end,
		keys = {
			{
				"<leader>dO",
				function()
					require("dap").step_out()
				end,
			},
			{
				"<leader>do",
				function()
					require("dap").step_over()
				end,
			},
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
			},
			{
				"<leader>da",
				function()
					if vim.fn.filereadable(".vscode/launch.json") then
						local dap_vscode = require("dap.ext.vscode")
						dap_vscode.load_launchjs(nil, {
							["pwa-node"] = js_based_languages,
							["chrome"] = js_based_languages,
							["pwa-chrome"] = js_based_languages,
						})
					end
					require("dap").continue()
				end,
			},
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
			},
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
			},
			{
				"<leader>dr",
				function()
					require("dap").repl.open()
				end,
			},
			{
				"<leader>dh",
				function()
					require("dap.ui.widgets").hover()
				end,
			},
			{
				"<leader>de",
				function()
					require("dap").terminate()
				end,
			},
		},
		dependencies = {
			{
				"theHamsta/nvim-dap-virtual-text",
				opts = {},
			},
			{
				"microsoft/vscode-js-debug",
				build = "npm install --legacy-peer-deps --no-save && npx gulp vsDebugServerBundle && rm -rf out && mv dist out",
				version = "1.*",
			},
			{
				"mxsdev/nvim-dap-vscode-js",
				config = function()
					require("dap-vscode-js").setup({
						debugger_path = vim.fn.resolve(vim.fn.stdpath("data") .. "/lazy/vscode-js-debug"),
						adapters = {
							"pwa-node",
						},
					})
				end,
			},
		},
	},
}
