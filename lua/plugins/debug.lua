local js_based_languages = {
	"typescript",
	"javascript",
}

return {
	{
		"mfussenegger/nvim-dap",
		commit = "567da83810dd9da32f9414d941bc6848715fc102",
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
	{
		"andtankian/nxtest.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {
			terminal_position = "vertical",
		},
	},
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = {
			float_opts = {
				border = "curved",
				width = 92 * 2,
			},
			autoscroll = false,
		},
		keys = {
			{
				"<C-t>",
				"<cmd>ToggleTerm 1 direction=float<cr>",
				desc = "Toggle floating terminal",
				mode = { "n", "t" },
			},
			{
				"<C-S-i>",
				"<cmd>ToggleTerm 2 direction=horizontal<cr>",
				desc = "Toggle horizontal terminal",
				mode = { "n", "t" },
			},
			{
				"<C-x>",
				"<C-\\><C-n>",
				mode = "t",
				desc = "Exit terminal mode",
			},
		},
	},
}
