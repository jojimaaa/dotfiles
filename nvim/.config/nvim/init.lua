require("config.lazy")

vim.g.mapleader=" "

-- Sets up 2 space tabs
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

-- Sets up colors
vim.opt.termguicolors = true
