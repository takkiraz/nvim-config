-- VIMRUNTIME only. Pulling all of runtimepath (nvim_get_runtime_file) makes lua_ls crawl
-- every installed plugin, see nvim-lspconfig#3189.
return {
    settings = {
        Lua = {
            workspace = {
                checkThirdParty = false,
                library = { vim.env.VIMRUNTIME },
            },
        },
    },
}
