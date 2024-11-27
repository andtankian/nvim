local M = {}

M.map = function(mode, key, action, opts)
	vim.keymap.set(mode, key, action, opts)
end

-- Helper function to convert hex to RGB
local function hex_to_rgb(hex)
	hex = hex:gsub("#", "")
	return tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)), tonumber("0x" .. hex:sub(5, 6))
end

-- Helper function to convert RGB to hex
local function rgb_to_hex(r, g, b)
	return string.format("#%02X%02X%02X", r, g, b)
end

-- Function to blend two colors
local function blend_colors(color1, color2, factor)
	local r1, g1, b1 = hex_to_rgb(color1)
	local r2, g2, b2 = hex_to_rgb(color2)

	local r = math.floor(r1 * (1 - factor) + r2 * factor)
	local g = math.floor(g1 * (1 - factor) + g2 * factor)
	local b = math.floor(b1 * (1 - factor) + b2 * factor)

	return rgb_to_hex(r, g, b)
end

-- Get the background color dynamically
local function get_background_color()
	local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal" })
	if normal_hl and normal_hl.bg then
		return string.format("#%06x", normal_hl.bg)
	end
	return "#000000" -- fallback to black if no background color is found
end

M.override_hl_groups = function()
	local bg_color = get_background_color()

	-- Blend background color with our diff colors
	local diff_add = blend_colors(bg_color, "#00FF00", 0.1) -- Blend with green
	local diff_delete = blend_colors(bg_color, "#FF0000", 0.1) -- Blend with red
	local diff_change = blend_colors(bg_color, "#FFFF00", 0.1) -- Blend with yellow
	local diff_text = blend_colors(bg_color, "#FFFF00", 0.2) -- Blend with yellow, stronger

	-- Apply the highlight groups
	vim.api.nvim_set_hl(0, "DiffAdd", { fg = "NONE", bg = diff_add })
	vim.api.nvim_set_hl(0, "DiffDelete", { fg = "NONE", bg = diff_delete })
	vim.api.nvim_set_hl(0, "DiffChange", { fg = "NONE", bg = diff_change })
	vim.api.nvim_set_hl(0, "DiffText", { fg = "NONE", bg = diff_text })
end

M.override_filetype = function()
	vim.filetype.add({
		extension = {
			tfvars = "terraform",
		},
	})
end


M.override_all = function()
	M.override_filetype()
	M.override_hl_groups()
end

return M
