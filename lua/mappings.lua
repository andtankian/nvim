local keymap = vim.keymap
local g = vim.g

keymap.set("n", "<Space>", "")
keymap.set("n", "<Esc>", "<cmd> noh <CR>")
keymap.set("n", "<C-h>", "<C-w>h")
keymap.set("n", "<C-l>", "<C-w>l")
keymap.set("n", "<C-j>", "<C-w>j")
keymap.set("n", "<C-k>", "<C-w>k")

g.mapleader = " "
