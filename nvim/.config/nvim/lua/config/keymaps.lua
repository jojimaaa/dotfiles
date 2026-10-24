-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap

-- Exit insert mode with jk
vim.api.nvim_set_keymap("i", "jk", "<Esc>", { noremap = false })

-- Center screen when jumping
vim.api.nvim_set_keymap("n", "<C-d>", "<C-d>zz", { noremap = false })
vim.api.nvim_set_keymap("n", "<C-u>", "<C-u>zz", { noremap = false })
vim.api.nvim_set_keymap("n", "n", "nzz", { noremap = false })
vim.api.nvim_set_keymap("n", "N", "Nzz", { noremap = false })

-- Move selected text down
keymap.set("v", "<M-j>", ":m '>+1<CR>gv=gv")
-- Move selected text up
keymap.set("v", "<M-k>", ":m '<-2<CR>gv=gv")

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>s-", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- Y to EOL
keymap.set("n", "Y", "y$", { desc = "Yank to end of line" })
