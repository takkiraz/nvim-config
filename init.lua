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
vim.o.hlsearch = true
vim.o.inccommand = 'split'
vim.o.backup = false
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
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down" })
vim.keymap.set('v', '<', "<gv")
vim.keymap.set('v', '>', ">gv")

-- go specific keymaps
vim.keymap.set('n', '<leader>gor', '<cmd>update <CR> <cmd>vsplit | terminal go run %<CR>', { desc = 'Run current file' })
-- Run tests in current directory
vim.keymap.set('n', '<leader>got', '<cmd>update <CR> <cmd>vsplit | terminal go test -v<CR>', { desc = 'Run tests' })

-- Close terminal buffer quickly
vim.keymap.set('n', '<leader>q', '<cmd>bd!<CR>', { desc = 'Close buffer' })
-- Exit terminal mode easily
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Autocommands
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight yanked text',
    callback = function()
        vim.highlight.on_yank({ timeout = 200 })
    end,
})

vim.api.nvim_create_user_command('GitBlameLine', function()
    local line_number = vim.fn.line('.')
    local filename = vim.api.nvim_buf_get_name(0)
    print(vim.system({ 'git', 'blame', '-L', line_number .. ',+1', filename }):wait().stdout)
end, { desc = 'Print the git blame for the current line' })

-- Plugins
vim.pack.add({
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'v0.10.0' },
    { src = 'https://github.com/saghen/blink.cmp',                version = 'v1.8.0' },
    { src = 'https://github.com/fang2hou/blink-copilot',          version = 'v1.4.1' },
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
    "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
})

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

-- Mason
require("mason").setup()

local capabilities = require('blink.cmp').get_lsp_capabilities()
local vue_language_server_path = vim.fn.stdpath('data') ..
    '/mason/packages/vue-language-server/node_modules/@vue/language-server'
local tsserver_filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' }
local vue_plugin = {
    name = '@vue/typescript-plugin',
    location = vue_language_server_path,
    languages = { 'vue' },
    configNamespace = 'typescript',
}
local ts_ls_config = {
    init_options = {
        plugins = { vue_plugin },
    },
    filetypes = tsserver_filetypes,
}
local lsp_servers = {
    ts_ls = ts_ls_config,
    vue_ls = {},
    gopls = {
        settings = {
            gopls = {
                standaloneTags = { "ignore", "mage" },
            },
        },
    },
    lua_ls = {
        settings = {
            Lua = {
                diagnostics = {
                    globals = { 'vim' },
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file('', true),
                    checkThirdParty = false,
                },
                telemetry = {
                    enable = false,
                },
            },
        },
    },
}
vim.lsp.config('ts_ls', ts_ls_config)
vim.lsp.config('vue_ls', {})
vim.lsp.enable({ 'vue_ls', 'ts_ls' })

require("mason-lspconfig").setup({
    ensure_installed = vim.tbl_keys(lsp_servers),
    handlers = {
        -- Default handler for all servers
        function(server_name)
            local config = lsp_servers[server_name] or {}
            config.capabilities = capabilities
            vim.lsp.config(server_name, config)
            vim.lsp.enable(server_name)
        end,
    },
})

require("mason-tool-installer").setup({
    ensure_installed = vim.tbl_keys(lsp_servers),
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
require('telescope').setup({})
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<CR>', { desc = 'Find Files' })
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', { desc = 'Grep' })
vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<CR>', { desc = 'Buffers' })
vim.keymap.set('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', { desc = 'Help' })
vim.keymap.set('n', '<leader>fc', '<cmd>Telescope commands<CR>', { desc = 'Commands' })
vim.keymap.set('n', '<leader>fm', '<cmd>Telescope marks<CR>', { desc = 'Marks' })
vim.keymap.set('n', '<leader>fs', '<cmd>Telescope lsp_document_symbols<CR>', { desc = 'Document Symbols' })
vim.keymap.set('n', '<C-p>', '<cmd>Telescope git_files<CR>', { desc = 'Open Git Files' })

-- Treesitter
require('nvim-treesitter.configs').setup({
    highlight = { enable = true },
    indent = { enable = true },
    ensure_installed = { 'go', 'lua', 'typescript', 'vue', 'json', 'yaml', 'bash', 'html', 'css', 'javascript' },
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
local lspconfig = require('lspconfig')
local lspconfig_defaults = lspconfig.util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
    'force',
    lspconfig_defaults.capabilities,
    require('blink.cmp').get_lsp_capabilities()
)
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
        map('<leader>f', require('conform').format, 'Format')
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
