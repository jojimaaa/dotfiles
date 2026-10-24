-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt

vim.g.lazyvim_picker = "telescope"

-- basic options
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.scrolloff = 10
opt.sidescrolloff = 8

-- Search options
opt.ignorecase = true
opt.smartcase = true

-- identation
opt.autoindent = true
opt.smartindent = true
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2

-- visuals
opt.termguicolors = true
opt.signcolumn = "yes"
opt.showmatch = true

opt.splitright = true
opt.splitbelow = true

-- file handling
opt.autoread = true
opt.autowrite = false
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true

-- behavior settings
opt.backspace = "indent,eol,start"
opt.errorbells = false
opt.iskeyword:append("-")
opt.clipboard:append("unnamedplus") -- use system clipboard
opt.path:append("**")
opt.mouse = "a"
opt.encoding = "utf-8"
