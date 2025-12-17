-- Leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Options
vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.cursorline = true
vim.o.linebreak = true
vim.o.scrolloff = 10
vim.o.signcolumn = 'yes'
vim.o.list = true
vim.o.listchars = 'tab:» ,lead:•,trail:•'
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = true
vim.o.inccommand = 'split'
vim.o.backup = false
vim.o.writebackup = false
vim.o.undofile = true
vim.o.swapfile = false
vim.o.mouse = 'a'
vim.o.clipboard = 'unnamedplus'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.winborder = 'rounded'
vim.o.splitright = true
vim.o.splitbelow = true

-- Keymaps
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('i', 'jj', '<Esc>')
vim.keymap.set('i', 'jk', '<Esc>')
vim.keymap.set('n', '<leader>d', '"_d')
vim.keymap.set('v', '<leader>d', '"_d')
vim.keymap.set('n', '<leader>a', '<cmd>split | terminal<CR>i')
vim.keymap.set('n', '<leader>ec', '<cmd>edit $MYVIMRC<CR>')
vim.keymap.set('n', '<leader>so', ':update<CR> :source<CR>')
vim.keymap.set('n', '<C-j>', '<cmd>move .+1<CR>==')
vim.keymap.set('n', '<C-k>', '<cmd>move .-2<CR>==')
vim.keymap.set('v', '<C-j>', ":move '>+1<CR>gv=gv")
vim.keymap.set('v', '<C-k>', ":move '<-2<CR>gv=gv")

-- go specific keymaps
vim.keymap.set('n', '<leader>r', '<cmd>update <CR> <cmd>vsplit | terminal go run %<CR>', { desc = 'Run current file' })
-- Run tests in current directory
vim.keymap.set('n', '<leader>t', '<cmd>update <CR> <cmd>vsplit | terminal go test -v<CR>', { desc = 'Run tests' })
-- Close terminal buffer quickly
vim.keymap.set('n', '<leader>q', '<cmd>bd!<CR>', { desc = 'Close buffer' })
-- Exit terminal mode easily
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Autocommands
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank({ timeout = 150 })
    end,
})

-- Plugins
vim.pack.add({
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    { src = 'https://github.com/saghen/blink.cmp' },
    { src = 'https://github.com/fang2hou/blink-copilot' },
    { src = 'https://github.com/catppuccin/nvim' },
    { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
    { src = 'https://github.com/nvim-telescope/telescope.nvim' },
    { src = 'https://github.com/nvim-lua/plenary.nvim' },
    { src = 'https://github.com/stevearc/oil.nvim' },
    { src = 'https://github.com/mbbill/undotree.git' },
})

-- Undotree
vim.keymap.set('n', '<leader>u', '<cmd>UndotreeToggle <CR>', { desc = 'Open Undotree' })

-- Colorscheme
vim.cmd.colorscheme('catppuccin-mocha')

-- Web Devicons
require('nvim-web-devicons').setup({ default = true })

-- Oil
require('oil').setup()
vim.keymap.set('n', '<leader>e', '<cmd>Oil<CR>', { desc = 'Open Oil' })

-- Telescope
require('telescope').setup()
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<CR>', { desc = 'Find Files' })
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', { desc = 'Grep' })
vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<CR>', { desc = 'Buffers' })
vim.keymap.set('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', { desc = 'Help' })
vim.keymap.set('n', '<C-p>', '<cmd>Telescope git_files<CR>', { desc = 'Open Git Files' })

-- Treesitter
require('nvim-treesitter.configs').setup({
    highlight = { enable = true },
    indent = { enable = true },
})

-- Completion
require('blink.cmp').setup({
    keymap = {
        preset = 'default',
        ['<Tab>'] = { 'accept', 'fallback' },
    },
    appearance = { nerd_font_variant = 'mono' },
    completion = { documentation = { auto_show = false } },
    sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'copilot' },
        providers = {
            copilot = {
                name = 'copilot',
                module = 'blink-copilot',
                score_offset = 100,
                async = true,
                opts = { max_completions = 3 },
            },
        },
    },
    fuzzy = { implementation = 'prefer_rust_with_warning' },
    signature = { enabled = true },
})

-- LSP
local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
    'force',
    lspconfig_defaults.capabilities,
    require('blink.cmp').get_lsp_capabilities()
)
vim.lsp.enable({'ts_ls', 'gopls', 'lua_ls', 'copilot' })

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(event)
        local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        map('gd', vim.lsp.buf.definition, 'Go to Definition')
        map('gr', vim.lsp.buf.references, 'Go to References')
        map('gr', '<cmd>Telescope lsp_references<CR>', 'Go to References')
        map('K', vim.lsp.buf.hover, 'Hover Documentation')
        map('<leader>rn', vim.lsp.buf.rename, 'Rename')
        map('<leader>ca', vim.lsp.buf.code_action, 'Code Action')
        map('<leader>f', vim.lsp.buf.format, 'Format')
        map('<leader>ld', vim.diagnostic.open_float, 'Show Diagnostics')
        map('<leader>j', vim.diagnostic.goto_next, 'Next Diagnostic')
        map('<leader>k', vim.diagnostic.goto_prev, 'Previous Diagnostic')
    end,
})
