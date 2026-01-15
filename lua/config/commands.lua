-- Custom user commands

-- LspInfo command - shows information about attached LSP clients
vim.api.nvim_create_user_command("LspInfo", function()
	local clients = vim.lsp.get_clients({ bufnr = 0 })

	if #clients == 0 then
		print("No LSP clients attached to this buffer")
		return
	end

	-- Create a new buffer for the output
	local buf = vim.api.nvim_create_buf(false, true)
	local lines = {}

	table.insert(lines, "LSP Client Information")
	table.insert(lines, "=====================")
	table.insert(lines, "")

	for _, client in ipairs(clients) do
		table.insert(lines, string.format("Client: %s (id: %d)", client.name, client.id))
		table.insert(lines, string.format("  Root directory: %s", client.config.root_dir or "N/A"))
		table.insert(lines, string.format("  Filetypes: %s", table.concat(client.config.filetypes or {}, ", ")))
		table.insert(lines, string.format("  Command: %s", table.concat(client.config.cmd or {}, " ")))
		table.insert(lines, string.format("  Auto-start: %s", client.config.autostart and "true" or "false"))

		-- Show capabilities summary
		local caps = client.server_capabilities
		table.insert(lines, "  Capabilities:")
		table.insert(lines, string.format("    - Hover: %s", caps.hoverProvider and "✓" or "✗"))
		table.insert(lines, string.format("    - Completion: %s", caps.completionProvider and "✓" or "✗"))
		table.insert(lines, string.format("    - Definition: %s", caps.definitionProvider and "✓" or "✗"))
		table.insert(lines, string.format("    - References: %s", caps.referencesProvider and "✓" or "✗"))
		table.insert(lines, string.format("    - Rename: %s", caps.renameProvider and "✓" or "✗"))
		table.insert(lines, string.format("    - Formatting: %s", caps.documentFormattingProvider and "✓" or "✗"))
		table.insert(lines, string.format("    - Code Action: %s", caps.codeActionProvider and "✓" or "✗"))
		table.insert(lines, "")
	end

	-- Show all configured LSP servers
	table.insert(lines, "Configured LSP Servers")
	table.insert(lines, "=====================")
	table.insert(lines, "")

	for name, config in pairs(vim.lsp.config) do
		if type(config) == "table" then
			local attached = false
			for _, client in ipairs(clients) do
				if client.name == name then
					attached = true
					break
				end
			end
			local status = attached and "✓ Attached" or "  Available"
			table.insert(lines, string.format("%s %s", status, name))
		end
	end

	-- Set the buffer content
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].modifiable = false
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].filetype = "lspinfo"

	-- Open in a new window
	vim.cmd("split")
	vim.api.nvim_win_set_buf(0, buf)

	-- Set buffer-local keymaps to close
	vim.keymap.set("n", "q", "<cmd>q<cr>", { buffer = buf, silent = true })
	vim.keymap.set("n", "<Esc>", "<cmd>q<cr>", { buffer = buf, silent = true })
end, { desc = "Show LSP client information" })

vim.api.nvim_create_autocmd({ "VimEnter" }, {
	callback = function()
		require("nvim-tree.api").tree.close()
	end,
})

vim.api.nvim_create_autocmd("User", {
	pattern = "TelescopePreviewerLoaded",
	callback = function(args)
		-- Only apply line numbers to regular files, not help files
		if args.data.filetype ~= "help" then
			vim.wo.number = true
		end
	end,
})
