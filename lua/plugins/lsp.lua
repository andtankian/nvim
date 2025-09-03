local helpers = require("config.utils.helpers")

local js_based_languages = {
	"typescript",
	"javascript",
}

--- Gets a path to a package in the Mason registry.
--- Prefer this to `get_package`, since the package might not always be
--- available yet and trigger errors.
---@param pkg string
---@param path? string
local function get_pkg_path(pkg, path)
	pcall(require, "mason")
	local root = vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")
	path = path or ""
	local ret = root .. "/packages/" .. pkg .. "/" .. path
	return ret
end

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

			require("dap").adapters["pwa-node"] = {
				type = "server",
				host = "localhost",
				port = "${port}",
				executable = {
					command = "node",
					args = {
						get_pkg_path("js-debug-adapter", "/js-debug/src/dapDebugServer.js"),
						"${port}",
					},
				},
			}

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
		},
	},
}
