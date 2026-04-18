local map = vim.keymap.set
local opts = { silent = true, noremap = true }

-- Window navigation (Ctrl+hjkl — matches your init.lua)
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Window splits (Space-/ and Space-- — from keybindings.nix)
map("n", "<leader>/", "<cmd>vsplit<cr>", { desc = "split vertical" })
map("n", "<leader>-", "<cmd>split<cr>", { desc = "split horizontal" })

-- Tabs
map("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "new tab" })
map("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "close tab" })

-- Misc
map("n", "<cr>", "o<esc>", opts)
map("n", "<leader>th", "<cmd>noh<cr>", { desc = "clear highlights" })
map("n", ";", ":", { noremap = true })

-- Telescope (Ctrl+f files, Ctrl+n grep — from init.lua)
map("n", "<C-f>", "<cmd>Telescope find_files<cr>", opts)
map("n", "<C-n>", "<cmd>Telescope live_grep<cr>", opts)

-- Stay centered on search / scroll
map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)

-- System clipboard (Space+y/d/p — from keybindings.nix)
map("n", "<leader>y", '"+y', { desc = "yank to clipboard" })
map("n", "<leader>Y", '"+y$', { desc = "yank line to clipboard" })
map("n", "<leader>d", '"+d', { desc = "delete to clipboard" })
map("n", "<leader>D", '"+d$', { desc = "delete line to clipboard" })
map("n", "<leader>p", '"+p', { desc = "paste from clipboard" })
map("n", "<leader>P", '"+P', { desc = "paste from clipboard" })

-- Visual mode — move selections (J/K — from keybindings.nix)
map("v", "J", ":m '>+1<cr>gv=gv", opts)
map("v", "K", ":m '<-2<cr>gv=gv", opts)
map("v", "<leader>y", '"+y', opts)
map("v", "<leader>d", '"+d', opts)
map("v", "<leader>p", '"+p', opts)
map("v", "<leader>P", '"+P', opts)
map("v", "<leader><leader>p", '"_dp', { desc = "paste keep register" })
map("v", "<leader><leader>P", '"_dP', { desc = "paste keep register" })

-- Oil (file browser)
map("n", "-", "<cmd>Oil<cr>", { desc = "open oil" })

-- Trouble
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "diagnostics" })
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "buffer diagnostics" })
