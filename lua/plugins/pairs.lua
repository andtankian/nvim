return {
	"saghen/blink.pairs",
	version = "*", -- (recommended) only required with prebuilt binaries
  event = "InsertEnter",

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
				['$'] = {}, -- Disable dollar sign pairing
			},
		},
		debug = false,
	},
}
