-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		lazyrepo,
		lazypath,
	})

	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end

-- Add lazy.nvim to runtime path
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
	-- Plugin specifications
	spec = {
		-- Import plugins from lua/plugins directory
		-- Each file in lua/plugins/ will be loaded as a plugin spec
		{ import = "plugins" },
	},

	-- Default settings for plugins
	defaults = {
		lazy = false, -- Plugins are not lazy-loaded by default
		version = false, -- Use latest git commit (not version tags)
	},

	-- Installation settings
	install = {
		-- Install missing plugins on startup
		missing = true,
		-- Colorscheme to use during installation
		colorscheme = { "catppuccin-mocha" },
	},

	-- Change detection
	change_detection = {
		enabled = false, -- Automatically check for config file changes
		notify = false, -- Don't notify about config changes
	},

	-- Performance settings
	performance = {
		cache = {
			enabled = true,
		},
		reset_packpath = true,
		rtp = {
			reset = true,
			---@type string[]
			paths = {},
			---@type string[] list of plugins to disable
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})
