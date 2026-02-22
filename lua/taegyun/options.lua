vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

-- tabs & indentation
vim.opt.tabstop=4
vim.opt.softtabstop=4
vim.opt.shiftwidth=4
vim.opt.expandtab=true  -- expand tab to space
vim.opt.autoindent=true
--vim.opt.smartindent = true -- account for comment

-- search settings
vim.opt.ignorecase=true  -- ignore case when search by default
vim.opt.smartcase=true   -- mixed case will trigger case sensitive search

-- terminal colour
vim.opt.termguicolors=true
vim.opt.background="dark"
vim.opt.signcolumn="yes"

-- split windows
vim.opt.splitright = true -- split window to right
vim.opt.splitbelow = true -- split window to bottom

-- undo
vim.opt.swapfile = false
vim.opt.backup=false
vim.opt.undodir = (os.getenv("HOME") or os.getenv("USERPROFILE")) .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 10
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 250

-- Whitespace characters
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Cursor related colour
vim.opt.cursorline = true
vim.opt.colorcolumn = "80"

vim.g.mapleader = " "

-- Tree style visualiser
vim.cmd("let g:netrw_liststyle = 3")

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup(
        'kickstart-highlight-yank',
        { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

