local opt = vim.opt
local o = vim.o

-- Amount of lines to scroll when the cursor reaches the end of the screen
opt.scrolloff = 10

-- Last window should have status line
opt.laststatus = 3

-- Do not show mode in the status line (default)
opt.showmode = false

-- Share system clipboard register
opt.clipboard = "unnamedplus"

-- Highlight current cursor line
opt.cursorline = true

-- Indenting
opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true
opt.tabstop = 2
opt.softtabstop = 2

-- Ignore case when executing commands and searching
opt.ignorecase = true

-- Override ignore case to some cases
opt.smartcase = true
opt.mouse = "a"

-- Numbers
opt.number = true
opt.relativenumber = true
opt.ruler = false
opt.signcolumn = "yes:1"
opt.numberwidth = 1

-- disable nvim intro
opt.shortmess:append("sI")

opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.timeoutlen = 400
opt.undofile = true

-- interval for writing swap file to disk, also used by gitsigns
opt.updatetime = 250

-- related to folding
o.foldcolumn = "0"
o.foldlevel = 99
o.foldlevelstart = 99
o.foldenable = true
