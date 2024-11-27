local utils = require("utils")

local g = vim.g

g.mapleader = " "
g.maplocalleader = " "

utils.map("n", "<Space>", "")
utils.map("n", "<Esc>", "<cmd> noh <CR>")
utils.map("n", "<C-h>", "<C-w>h")
utils.map("n", "<C-l>", "<C-w>l")
utils.map("n", "<C-j>", "<C-w>j")
utils.map("n", "<C-k>", "<C-w>k")

-- Buffer navigation
utils.map("n", "<Tab>", "<cmd>bnext<CR>")
utils.map("n", "<S-Tab>", "<cmd>bprevious<CR>")
utils.map("n", "<leader>x", "<cmd>bp|bd #<CR>")
utils.map("n", "<leader>X", "<cmd>%bdelete<CR>")
