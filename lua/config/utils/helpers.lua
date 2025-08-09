-- Helper functions for color manipulation in Neovim
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

-- Keymap function to set key mappings
local function keymap(mode, key, action, opts)
	vim.keymap.set(mode, key, action, opts)
end

local function tbl_values(t)
	local values = {}
	for _, v in pairs(t) do
		table.insert(values, v)
	end
	return values
end

return {
	get_background_color = get_background_color,
	blend_colors = blend_colors,
	hex_to_rgb = hex_to_rgb,
	rgb_to_hex = rgb_to_hex,
	keymap = keymap,
	tbl_values = tbl_values,
}
