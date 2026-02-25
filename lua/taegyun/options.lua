vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Enable mouse mode
vim.o.mouse = "a"

-- tabs & indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true

-- Enable break indent
vim.o.breakindent = true

-- search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- terminal colour
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.signcolumn = "yes"

-- split windows
vim.opt.splitright = true
vim.opt.splitbelow = true

-- undo
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = (os.getenv("HOME") or os.getenv("USERPROFILE")) .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time (important for which-key responsiveness)
vim.o.timeoutlen = 300

vim.opt.scrolloff = 10
vim.opt.isfname:append("@-@")

-- Whitespace characters
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.o.inccommand = "split"

-- Cursor related colour
vim.opt.cursorline = true
vim.opt.colorcolumn = "80"

-- If performing an operation that would fail due to unsaved changes,
-- raise a dialog asking if you wish to save
vim.o.confirm = true

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})
