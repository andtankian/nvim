-- Leader key configuration
-- Set leader key to space (must be set before lazy.nvim)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Use a local variable for cleaner syntax
local opt = vim.opt

-- ============================================================================
-- UI and Appearance
-- ============================================================================

-- Show line numbers
opt.number = true

-- Show relative line numbers (useful for motions like 5j, 10k)
opt.relativenumber = true

-- Highlight the current line
opt.cursorline = true

-- Show sign column always (prevents text shifting when signs appear)
opt.signcolumn = "yes"

-- Enable 24-bit RGB color in the TUI
opt.termguicolors = true

-- Minimum number of screen lines to keep above and below the cursor
opt.scrolloff = 8

-- Minimum number of screen columns to keep to the left and right of the cursor
opt.sidescrolloff = 8

-- Show command in the last line of the screen
opt.showcmd = true

-- Always show the status line
opt.laststatus = 3

-- Don't show mode in command line (status line plugins usually show this)
opt.showmode = false

-- Enable mouse support in all modes
opt.mouse = "a"

-- Display unprintable characters
opt.list = true
opt.listchars = {
	tab = "  ",
	trail = "·",
	nbsp = "␣",
	extends = "⟩",
	precedes = "⟨",

}
-- Configure how new splits should be opened
opt.splitright = true -- Vertical splits go to the right
opt.splitbelow = true -- Horizontal splits go below

-- Hide the command line when not in use
opt.cmdheight = 1

-- ============================================================================
-- Indentation and Formatting
-- ============================================================================

-- Use spaces instead of tabs
opt.expandtab = true

-- Number of spaces for each indentation level
opt.shiftwidth = 2

-- Number of spaces a <Tab> counts for while editing
opt.tabstop = 2

-- Number of spaces a <Tab> counts for while performing editing operations
opt.softtabstop = 2

-- Copy indent from current line when starting a new line
opt.autoindent = true

-- Enable smart indentation
opt.smartindent = true

-- Round indent to multiple of shiftwidth
opt.shiftround = true

-- ============================================================================
-- Search and Replace
-- ============================================================================

-- Ignore case in search patterns
opt.ignorecase = true

-- Override ignorecase if search pattern contains uppercase
opt.smartcase = true

-- Highlight all matches of the search pattern
opt.hlsearch = true

-- Show search matches as you type
opt.incsearch = true

-- Use global flag by default in substitute commands
opt.gdefault = true

-- ============================================================================
-- File Handling
-- ============================================================================

-- Use system clipboard for all operations
opt.clipboard = "unnamedplus"

-- Enable persistent undo
opt.undofile = true

-- Save undo history to this directory
opt.undodir = vim.fn.stdpath("data") .. "/undo"

-- Disable backup files
opt.backup = false

-- Disable swap files (use undofile instead)
opt.swapfile = false

-- Write swap file to disk after this many milliseconds
opt.updatetime = 250

-- Time in milliseconds to wait for a mapped sequence
opt.timeoutlen = 300

-- Enable file type detection, plugins, and indent files
vim.cmd("filetype plugin indent on")

-- ============================================================================
-- Text Editing
-- ============================================================================

-- Disable line wrapping
opt.wrap = false

-- Allow backspace over indentation, line breaks, and insertion start
opt.backspace = "indent,eol,start"

-- Allow cursor to move where there is no text in visual block mode
opt.virtualedit = "block"

-- Enable auto-write when leaving modified buffer
opt.autowrite = true

-- Automatically read file when changed outside of Vim
opt.autoread = true

-- ============================================================================
-- Completion and Wildmenu
-- ============================================================================

-- Command-line completion mode
opt.wildmode = "longest:full,full"

-- Ignore case when completing file names
opt.wildignorecase = true

-- Enhanced command-line completion
opt.wildmenu = true

-- Files to ignore in wildmenu
opt.wildignore = {
	"*.o",
	"*.obj",
	"*.dll",
	"*.exe",
	"*.so",
	"*.a",
	"*.lib",
	"*.pyc",
	"*.pyo",
	"*.pyd",
	"*.class",
	"*.cache",
	"*.swp",
	"*~",
	"*.bak",
	".git/*",
	".hg/*",
	".svn/*",
	"node_modules/*",
	".DS_Store",
}

-- Set completeopt for better completion experience
opt.completeopt = "menu,menuone,noselect"

-- ============================================================================
-- Performance
-- ============================================================================

-- Faster completion (default is 4000ms)
opt.updatetime = 250

-- Don't pass messages to |ins-completion-menu|
opt.shortmess:append("c")

-- Maximum number of items in popup menu
opt.pumheight = 10

-- Reduce time for which messages are shown
opt.timeout = true
opt.timeoutlen = 300

-- Enable lazy redraw (improves performance for macros)
opt.lazyredraw = false

-- ============================================================================
-- Folding
-- ============================================================================

-- Disable folding by default
opt.foldenable = false

-- Fold method (manual, indent, expr, syntax, diff, marker)
opt.foldmethod = "expr"

-- Use treesitter for folding if available
opt.foldexpr = "nvim_treesitter#foldexpr()"

-- Start with all folds open
opt.foldlevelstart = 99

-- ============================================================================
-- Miscellaneous
-- ============================================================================

-- Set grep program to use ripgrep if available
if vim.fn.executable("rg") == 1 then
	opt.grepprg = "rg --vimgrep --no-heading --smart-case"
	opt.grepformat = "%f:%l:%c:%m"
end

-- Confirm to save changes before exiting modified buffer
opt.confirm = true

-- Disable netrw (we'll use modern file explorers)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Set spelling language
opt.spelllang = "en_us"

-- Disable spell checking by default
opt.spell = false

-- Format options (see :help fo-table)
opt.formatoptions = "jcroqlnt"

-- Disable intro message
opt.shortmess:append("I")

-- Set session options
opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Better diffing
opt.diffopt:append("linematch:60")

-- Concealment settings for specific syntax elements
opt.conceallevel = 0

-- Increase max memory for pattern matching
opt.maxmempattern = 5000
