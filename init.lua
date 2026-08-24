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
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8
vim.o.signcolumn = 'yes'
vim.o.list = true
vim.o.listchars = 'tab:» ,lead:•,trail:•'
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.inccommand = 'split'
vim.o.writebackup = false
vim.o.undofile = true
vim.o.swapfile = false
vim.o.mouse = 'a'

vim.api.nvim_create_autocmd('UIEnter', {
    callback = function()
        vim.o.clipboard = 'unnamedplus'
    end,
})

vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.exrc = true -- load .nvim.lua from project directories
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
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down" })
vim.keymap.set('v', '<', "<gv")
vim.keymap.set('v', '>', ">gv")

-- Go specific keymaps
vim.keymap.set('n', '<leader>Gor', '<cmd>update <CR> <cmd>vsplit | terminal go run %<CR>',
    { desc = 'Go: Run current file' })
vim.keymap.set('n', '<leader>Got', '<cmd>update <CR> <cmd>vsplit | terminal go test -v<CR>', { desc = 'Go: Run tests' })

-- Close terminal buffer quickly
vim.keymap.set('n', '<leader>q', '<cmd>bd!<CR>', { desc = 'Close buffer' })
-- Exit terminal mode easily
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Autocommands
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight yanked text',
    callback = function()
        vim.hl.on_yank({ timeout = 200 })
    end,
})



-- Plugins
vim.pack.add({
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
    { src = 'https://github.com/saghen/blink.cmp',                version = 'v1.8.0' },
    { src = 'https://github.com/nvim-tree/nvim-web-devicons',     version = '8dcb311b0c92d460fac00eac706abd43d94d68af' },
    { src = 'https://github.com/nvim-telescope/telescope.nvim',   version = 'v0.2.0' },
    { src = 'https://github.com/nvim-lua/plenary.nvim',           version = 'b9fd5226c2f76c951fc8ed5923d85e4de065e509' },
    { src = 'https://github.com/stevearc/oil.nvim',               version = 'v2.15.0' },
    { src = 'https://github.com/mbbill/undotree.git',             version = '0f1c9816975b5d7f87d5003a19c53c6fd2ff6f7f' },
    { src = 'https://github.com/williamboman/mason.nvim',         version = 'v2.1.0' },
    { src = 'https://github.com/mason-org/mason-lspconfig.nvim',  version = 'v2.1.0' },
    { src = 'https://github.com/stevearc/conform.nvim.git',       version = 'v9.1.0' },
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    { src = 'https://github.com/catppuccin/nvim' },
    { src = 'https://github.com/lewis6991/gitsigns.nvim',         version = 'v2.0.0' },
    { src = 'https://github.com/folke/which-key.nvim',            version = 'v3.17.0' },
    "https://github.com/mfussenegger/nvim-lint",
    "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
    "https://github.com/ThePrimeagen/vim-be-good",
    "https://github.com/MeanderingProgrammer/render-markdown.nvim",
})

-- Linting
local lint = require('lint')

lint.linters_by_ft = {
    javascript = { 'eslint_d' },
    typescript = { 'eslint_d' },
    javascriptreact = { 'eslint_d' },
    typescriptreact = { 'eslint_d' },
    vue = { 'eslint_d' },
}

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
    callback = function()
        lint.try_lint()
    end,
})

vim.keymap.set("n", "<leader>ln", function()
    lint.try_lint()
end, { desc = "Trigger linting for current file" })

-- Conform
require('conform').setup({
    format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
        end
        return { timeout_ms = 500, lsp_format = "fallback" }
    end,
    formatters_by_ft = {
        lua = { 'stylua' },
        go = { 'gofmt', 'gofumpt', 'goimports' },
        javascript = { 'prettierd' },
        typescript = { 'prettierd' },
        javascriptreact = { 'prettierd' },
        typescriptreact = { 'prettierd' },
        vue = { 'prettierd' },
        json = { 'prettierd' },
        yaml = { 'prettierd' },
        css = { 'prettierd' },
        html = { 'prettierd' },
        bash = { 'shfmt' },
    },
})

-- LSP servers
-- Per-server settings live in lsp/<name>.lua. blink's capabilities are registered globally
-- here, before mason-lspconfig enables anything.
vim.lsp.config('*', { capabilities = require('blink.cmp').get_lsp_capabilities(nil, true) })

require('mason').setup()

local servers = { 'jsonls', 'ts_ls', 'vue_ls', 'gopls', 'lua_ls', 'bashls' }

require('mason-lspconfig').setup({
    ensure_installed = servers,
    -- Only these get enabled. Without the list, mason-lspconfig starts an LSP for every
    -- installed mason package that happens to have one, e.g. `stylua --lsp` next to lua_ls.
    automatic_enable = vim.list_extend({ 'copilot' }, servers),
})

-- The formatters and linters that conform and nvim-lint call
require('mason-tool-installer').setup({
    ensure_installed = { 'stylua', 'shfmt', 'gofumpt', 'goimports', 'prettierd', 'eslint_d' },
})
-- Undotree
vim.keymap.set('n', '<leader>u', '<cmd>UndotreeToggle <CR>', { desc = 'Open Undotree' })

-- Colorscheme
vim.cmd.colorscheme('catppuccin-mocha')

-- Web Devicons
require('nvim-web-devicons').setup({ default = true })

-- Oil
require('oil').setup(
    { view_options = { show_hidden = true, }, })

vim.keymap.set('n', '<leader>e', '<cmd>Oil<CR>', { desc = 'Open Oil' })

-- Lazygit (floating terminal)
vim.keymap.set('n', '<leader>gg', function()
    local buf = vim.api.nvim_create_buf(false, true)
    local width = math.floor(vim.o.columns * 0.9)
    local height = math.floor(vim.o.lines * 0.9)
    vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        width = width,
        height = height,
        col = math.floor((vim.o.columns - width) / 2),
        row = math.floor((vim.o.lines - height) / 2),
        style = 'minimal',
        border = 'rounded',
    })
    vim.fn.jobstart('lazygit', {
        term = true,
        on_exit = function()
            vim.api.nvim_buf_delete(buf, { force = true })
        end,
    })
    vim.cmd('startinsert')
end, { desc = 'Open Lazygit' })

-- Gitsigns
require('gitsigns').setup({
    on_attach = function(bufnr)
        local gs = require('gitsigns')

        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
            if vim.wo.diff then
                vim.cmd.normal({ ']c', bang = true })
            else
                gs.nav_hunk('next')
            end
        end, { desc = 'Next hunk' })

        map('n', '[c', function()
            if vim.wo.diff then
                vim.cmd.normal({ '[c', bang = true })
            else
                gs.nav_hunk('prev')
            end
        end, { desc = 'Previous hunk' })

        -- Actions
        map('n', '<leader>gs', gs.stage_hunk, { desc = 'Git: Stage hunk' })
        map('v', '<leader>gs', function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end,
            { desc = 'Git: Stage hunk' })
        map('n', '<leader>gr', gs.reset_hunk, { desc = 'Git: Reset hunk' })
        map('v', '<leader>gr', function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end,
            { desc = 'Git: Reset hunk' })
        map('n', '<leader>gp', gs.preview_hunk, { desc = 'Git: Preview hunk' })
        map('n', '<leader>gb', function() gs.blame_line({ full = true }) end, { desc = 'Git: Blame line' })

        -- Text object
        map({ 'o', 'x' }, 'ih', gs.select_hunk, { desc = 'Select hunk' })
    end,
})

-- Which-key
require('which-key').setup()
require('which-key').add({
    { '<leader>f', group = 'Find' },
    { '<leader>g', group = 'Git' },
    { '<leader>G', group = 'Go' },
    { '<leader>l', group = 'LSP' },
    { '<leader>t', group = 'Toggle' },
})

-- Telescope
require('telescope').setup({
    defaults = {
        path_display = { 'filename_first' },
        file_ignore_patterns = { '%.git/' }, -- search dotfiles, but not .git/
    },
    pickers = {
        find_files = {
            hidden = true,
        },
        live_grep = {
            additional_args = { '--hidden' },
        },
        buffers = {
            sort_lastused = true,
            mappings = {
                i = {
                    ["<c-c>"] = "delete_buffer",
                }
            }
        }
    }
})
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<CR>', { desc = 'Find Files' })
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', { desc = 'Grep' })
vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<CR>', { desc = 'Buffers' })
vim.keymap.set('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', { desc = 'Help' })
vim.keymap.set('n', '<leader>fc', '<cmd>Telescope commands<CR>', { desc = 'Commands' })
vim.keymap.set('n', '<leader>fm', '<cmd>Telescope marks<CR>', { desc = 'Marks' })
vim.keymap.set('n', '<leader>fs', '<cmd>Telescope lsp_document_symbols<CR>', { desc = 'Document Symbols' })
vim.keymap.set('n', '<C-p>', '<cmd>Telescope git_files<CR>', { desc = 'Open Git Files' })

-- Treesitter
require('nvim-treesitter').install({ 'markdown', 'markdown_inline' })

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'markdown',
    callback = function() pcall(vim.treesitter.start) end,
})

-- Render Markdown
require('render-markdown').setup({
    file_types = { 'markdown' },
    render_modes = { 'n', 'c', 't' },
    heading = {
        sign = false,
        icons = { '# ', '## ', '### ', '#### ', '##### ', '###### ' },
    },
    code = {
        sign = false,
        width = 'block',
        right_pad = 1,
    },
    bullet = {
        icons = { '●', '○', '◆', '◇' },
    },
    checkbox = {
        unchecked = { icon = '[ ] ' },
        checked   = { icon = '[x] ' },
    },
})

vim.keymap.set('n', '<leader>tm', '<cmd>RenderMarkdown toggle<CR>', { desc = 'Toggle Markdown Render' })

-- Completion
require('blink.cmp').setup({
    keymap = {
        preset = 'default',
        ['<Tab>'] = { 'accept', 'fallback' },
    },
    appearance = { nerd_font_variant = 'mono' },
    completion = { documentation = { auto_show = false } },
    sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
    fuzzy = { implementation = 'prefer_rust_with_warning' },
    signature = { enabled = true },
})

-- LSP keymaps and diagnostics
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if not client then
            return
        end

        local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        map('gd', '<cmd>Telescope lsp_definitions<CR>', 'Go to Definition')
        map('gD', vim.lsp.buf.declaration, 'Go to Declaration')
        map('gi', '<cmd>Telescope lsp_implementations<CR>', 'Go to Implementation')
        map('gy', '<cmd>Telescope lsp_type_definitions<CR>', 'Go to Type Definition')
        map('gr', '<cmd>Telescope lsp_references<CR>', 'Go to References')

        map('K', vim.lsp.buf.hover, 'Hover Documentation')
        map('<C-k>', vim.lsp.buf.signature_help, 'Signature Help')
        vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, { buffer = event.buf, desc = 'LSP: Signature Help' })

        map('<leader>rn', vim.lsp.buf.rename, 'Rename')
        map('<leader>ca', vim.lsp.buf.code_action, 'Code Action')
        map('<leader>lf', function()
            require('conform').format {
                async = true, lsp_format = "fallback", timeout_ms = 500
            }
        end, 'Format')
        map('<leader>ld', vim.diagnostic.open_float, 'Show Diagnostics')
        map('<leader>ll', '<cmd>Telescope diagnostics bufnr=0<CR>', 'Document Diagnostics')
        map('<leader>lw', '<cmd>Telescope diagnostics<CR>', 'Workspace Diagnostics')

        map('[d', function()
            vim.diagnostic.jump({ count = -1, float = true })
        end, 'Previous Diagnostic')
        map(']d', function()
            vim.diagnostic.jump({ count = 1, float = true })
        end, 'Next Diagnostic')
        map('[e', function()
            vim.diagnostic.jump({ count = -1, float = true, severity = vim.diagnostic.severity.ERROR })
        end, 'Previous Diagnostic')
        map(']e', function()
            vim.diagnostic.jump({ count = 1, float = true, severity = vim.diagnostic.severity.ERROR })
        end, 'Next Diagnostic')
    end,
})
vim.diagnostic.config({
    virtual_text = { prefix = '●' },
    signs = true,
})

vim.keymap.set('n', '<leader>td', function()
    local config = vim.diagnostic.config()
    if config == nil then return end
    vim.diagnostic.config({ virtual_text = not config.virtual_text })
end, { desc = 'Toggle Diagnostics' })


vim.lsp.inline_completion.enable(true)
-- toggle inline completion
vim.keymap.set('n', '<leader>ic', function()
    local enabled = vim.lsp.inline_completion.is_enabled()
    vim.lsp.inline_completion.enable(not enabled)
    if enabled then
        print('Disabled inline completion')
    else
        print('Enabled inline completion')
    end
end, { desc = 'Toggle inline completion' })

vim.keymap.set('i', '<Tab>', function()
    if not vim.lsp.inline_completion.get() then
        return '<Tab>'
    end
end, { expr = true, desc = 'Accept the current inline completion' })
