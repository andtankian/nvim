local helpers = require("config.utils.helpers")

local function disable_default_keykeymappings()
	local globals = { "grn", "gra", "grr", "gri", "gO", "]d", "[d" }
	for _, key in pairs(globals) do
		vim.keymap.del("n", key)
	end
end

local function lsp_attach()
	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(args)
			local bufnr = args.buf

			helpers.keymap("n", "<leader>f", vim.diagnostic.open_float, { buffer = bufnr, desc = "Show diagnostics" })
			helpers.keymap("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to definition" })
			helpers.keymap("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr, desc = "Go to implementation" })
			helpers.keymap("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename symbol" })
			helpers.keymap("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code action" })
			helpers.keymap("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "List references" })
			helpers.keymap("n", "]d", function()
				vim.diagnostic.jump({ count = 1, float = true })
			end)
			helpers.keymap("n", "[d", function()
				vim.diagnostic.jump({ count = -1, float = true })
			end)
			helpers.keymap("n", "<leader>fa", function()
				vim.lsp.buf.code_action({
					filter = function(a)
						return a.isPreferred
					end,
					apply = true,
				})
			end)
		end,
	})
end

local function enable()
	disable_default_keykeymappings()
	lsp_attach()

	for key, _ in pairs(require("config.externals").lsp) do
		vim.lsp.enable(key)
	end
end

enable()
