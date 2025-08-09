local helpers = require("config.utils.helpers")

local function override_hl_groups()
	local bg_color = helpers.get_background_color()

	-- Blend background color with our diff colors
	local diff_add = helpers.blend_colors(bg_color, "#00FF00", 0.1) -- Blend with green
	local diff_delete = helpers.blend_colors(bg_color, "#FF0000", 0.1) -- Blend with red
	local diff_change = helpers.blend_colors(bg_color, "#FFFF00", 0.1) -- Blend with yellow
	local diff_text = helpers.blend_colors(bg_color, "#FFFF00", 0.2) -- Blend with yellow, stronger
	local dap_stopped = helpers.blend_colors(bg_color, "#ef4000", 0.8) -- Blend with orange, stronger

	-- Apply the highlight groups
	vim.api.nvim_set_hl(0, "DiffAdd", { fg = "NONE", bg = diff_add })
	vim.api.nvim_set_hl(0, "DiffDelete", { fg = "NONE", bg = diff_delete })
	vim.api.nvim_set_hl(0, "DiffChange", { fg = "NONE", bg = diff_change })
	vim.api.nvim_set_hl(0, "DiffText", { fg = "NONE", bg = diff_text })
	vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#ef4000" })
	vim.api.nvim_set_hl(0, "DapStopped", { fg = dap_stopped })
	vim.api.nvim_set_hl(0, "@comment", { italic = true, fg = "#6c757d" })
end

local function override_filetype()
	vim.filetype.add({
		extension = {
			tfvars = "terraform",
		},
	})
end

local function override_signs()
	vim.fn.sign_define("DapBreakpoint", {
		text = "",
		texthl = "DapBreakpoint",
		linehl = "",
		numhl = "",
	})
	vim.fn.sign_define("DapStopped", {
		text = "󰮺",
		texthl = "DapStopped",
		linehl = "",
		numhl = "",
	})

	vim.diagnostic.config({
		signs = {
			active = true,
			text = {
				[vim.diagnostic.severity.ERROR] = "",
				[vim.diagnostic.severity.WARN] = "",
				[vim.diagnostic.severity.INFO] = "H",
				[vim.diagnostic.severity.HINT] = "",
			},
		},
		underline = true,
		update_in_insert = false,
		severity_sort = true,
		float = {
			border = "rounded",
		},
	})
end

override_filetype()
override_signs()
override_hl_groups()
