return {
	{
		"mfussenegger/nvim-dap",
		keys = {
			{ "<leader>dc", function() require("dap").continue() end, desc = "Start/Continue" },
			{ "<leader>do", function() require("dap").step_over() end, desc = "Step over" },
			{ "<leader>di", function() require("dap").step_into() end, desc = "Step into" },
			{ "<leader>du", function() require("dap").step_out() end, desc = "Step out" },
			{ "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
			{
				"<leader>dB",
				function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
				desc = "Conditional breakpoint",
			},
			{ "<leader>dr", function() require("dap").restart() end, desc = "Restart session" },
			{ "<leader>dt", function() require("dap").terminate() end, desc = "Terminate session" },
			{ "<leader>dl", function() require("dap").run_last() end, desc = "Re-run last config" },
		},
		config = function()
			local dap = require("dap")

			dap.adapters["pwa-node"] = {
				type = "server",
				host = "localhost",
				port = "${port}",
				executable = {
					command = "node",
					args = {
						vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
						"${port}",
					},
				},
			}

			local js_configs = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					cwd = "${workspaceFolder}",
				},
				{
					type = "pwa-node",
					request = "attach",
					name = "Attach to process",
					processId = require("dap.utils").pick_process,
					cwd = "${workspaceFolder}",
				},
			}

			for _, lang in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
				dap.configurations[lang] = js_configs
			end
		end,
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		dependencies = { "mfussenegger/nvim-dap" },
		opts = {},
	},
}
