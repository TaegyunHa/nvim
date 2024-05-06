vim.g.mapleader = " "

-- Go out to directory tree
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Exit insert mode with jj
vim.keymap.set("i", "jj", "<Esc>")

-- Window management
vim.keymap.set("n", "<leader>sv", "<C-w>v", {desc = "Split window vertically"})
vim.keymap.set("n", "<leader>sh", "<C-w>s", {desc = "Split window horizontally"})
vim.keymap.set("n", "<leader>se", "<C-w>=", {desc = "Make splits equal size"})
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>", {desc = "Close current split"})

-- Tab management
vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", {desc = "Open new tab"})
vim.keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", {desc = "Close current tab"})
vim.keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", {desc = "Go to next tab"})
vim.keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", {desc = "Go to previous tab"})
vim.keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", {desc = "Open current buffer in new tab"})

-- Move selected block up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Keep cursor at the begining of the line
vim.keymap.set("n", "J", "mzJ'z")

-- Keep cursor at the middle
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Keep vim clipboard after paste in block
vim.keymap.set("x", "<leader>p", "\"_dP")

-- Yank into system clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

-- Cut into system clipboard
vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

-- Disable Q
vim.keymap.set("n", "Q", "<nop>")

-- Quick fix 
--vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
--vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Replace all same words on cursor
vim.keymap.set("n", "<leader>rs", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Change current file to excutable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Source curront file
vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)

