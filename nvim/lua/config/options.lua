local o = vim.opt

-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Line numbers (hybrid — matches your NixOS config)
o.relativenumber = true
o.number = true

-- Indentation (4 spaces — matches your init.lua)
o.smartindent = true
o.autoindent = true
o.expandtab = true
o.tabstop = 4
o.shiftwidth = 4
o.shiftround = true

-- Search
o.ignorecase = true
o.smartcase = true
o.incsearch = true
o.hlsearch = true

-- UI
o.termguicolors = true
o.cursorline = true
o.scrolloff = 5
o.wrap = false
o.splitright = true
o.splitbelow = true
o.showmode = false
o.laststatus = 3
o.pumheight = 6
o.signcolumn = "yes"

-- System clipboard
o.clipboard = "unnamedplus"

-- Mouse
o.mouse = "a"

-- Undo / backup
o.undofile = true
o.backup = false
o.swapfile = false
o.writebackup = false

-- Perf
o.ttimeoutlen = 5
o.updatetime = 100
o.completeopt = "menuone,noselect"

-- Shell (PowerShell on Windows)
o.shell = "pwsh"
o.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
o.shellxquote = ""
o.shellquote = ""
o.shellpipe = "| Out-File -Encoding UTF8 %s"
o.shellredir = "| Out-File -Encoding UTF8 %s"
