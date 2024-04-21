local utils = require("utils")

local g = vim.g

utils.map("n", "<Space>", "")
utils.map("n", "<Esc>", "<cmd> noh <CR>")
utils.map("n", "<C-h>", "<C-w>h")
utils.map("n", "<C-l>", "<C-w>l")
utils.map("n", "<C-j>", "<C-w>j")
utils.map("n", "<C-k>", "<C-w>k")

g.mapleader = " "
