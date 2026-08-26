return {
	"saghen/blink.pairs",
	version = "*", -- (recommended) only required with prebuilt binaries
	event = "InsertEnter",

	build = function()
		require("blink.pairs").download():pwait(60000)
	end,

	-- download prebuilt binaries from github releases
	dependencies = "saghen/blink.download",

	--- @module 'blink.pairs'
	--- @type blink.pairs.Config
	opts = {
		highlights = {
			enabled = true,
			matchparen = {
				enabled = true,
			},
		},
		mappings = {
			pairs = {
				["$"] = {}, -- Disable dollar sign pairing
			},
		},
		debug = false,
	},
}
