vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- Keymaps
local map = vim.keymap.set
map('n', '<leader>cb', 'terminal swift build<CR>', { desc = 'Swift build' })
