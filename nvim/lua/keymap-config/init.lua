-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', 'th', ':set hls!<CR>', { noremap = true, desc = '[T]oggle Search [H]ighlight' })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Keymaps for NvimTree 
vim.keymap.set('n', '<leader>b', ":NvimTreeToggle<CR>", { desc = 'Toggle directory tree' })

-- Telescope keymaps
-- Keymap to change directory using zoxide
vim.keymap.set('n', '<leader>cd', ':Telescope zoxide list<CR>', { desc = '[C]hange [D]irectory' })

-- Keymap to source nvim config every time nvim config is updated without closing nvim
vim.keymap.set('n', '<leader>sc', ':source ~/.config/nvim/init.lua<CR>', { desc = '[S]ource Nvim [C]onfig' })
