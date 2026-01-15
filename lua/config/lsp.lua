local externals = require("config.externals")
local languages = externals.languages

-- Configure diagnostics
vim.diagnostic.config({
	virtual_text = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "🚨",
			[vim.diagnostic.severity.WARN] = "🚧",
			[vim.diagnostic.severity.HINT] = "💡",
			[vim.diagnostic.severity.INFO] = "ℹ️",
		},
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
		header = "",
		prefix = "",
	},
})

local function disable_default_keymaps()
	local globals = { "grn", "gra", "grr", "gri", "gO" }
	for _, key in pairs(globals) do
		vim.keymap.del("n", key)
	end
end

-- Configure LSP handlers for better UI
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

-- LSP Attach autocmd for keymaps and configurations
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
	callback = function(args)
		local bufnr = args.buf
		local client = vim.lsp.get_client_by_id(args.data.client_id)

		-- Enable inlay hints if supported
		if client and client.server_capabilities.inlayHintProvider then
			vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
		end

		-- Buffer-local keymaps
		local opts = { buffer = bufnr, silent = true }

		-- Note: Neovim 0.11+ includes these default mappings:
		-- grr - vim.lsp.buf.references()
		-- gri - vim.lsp.buf.implementation()
		-- grn - vim.lsp.buf.rename()
		-- K   - vim.lsp.buf.hover()
		-- gO  - document symbols
		-- [d, ]d - diagnostic navigation

		-- Additional useful mappings that complement the defaults
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
		vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Go to references" }))
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature help" }))
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename variable" }))
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
		vim.keymap.set("n", "<leader>fa", function()
			vim.lsp.buf.code_action({ apply = true })
		end, vim.tbl_extend("force", opts, { desc = "Apply preferred code action" }))

		-- Diagnostic keymaps (complement the defaults)
		vim.keymap.set(
			"n",
			"<leader>f",
			vim.diagnostic.open_float,
			vim.tbl_extend("force", opts, { desc = "Show line diagnostics" })
		)
	end,
})

disable_default_keymaps()

-- Enable all configured language servers
for key, _ in pairs(languages) do
	vim.lsp.enable(key)
end
