-- [[ Configure mason ]]

-- mason.setup must always preceed mason-lspconfig.setup
require('mason').setup()

local lspconfig = require('lsp-config')

-- Register our LSP keymaps (on LspAttach) and server configuration
-- (capabilities + lua_ls settings) via the native vim.lsp API. This replaces
-- the old mason-lspconfig `handlers` mechanism, removed in mason-lspconfig v2.
lspconfig.setup_lsp_attach()
lspconfig.configure_servers()

-- list of nvim-lspconfig servers to install
-- :lua P(require('mason-lspconfig').get_installed_servers())
-- must install java-debug-adapter and java-test via mason if jdtls is installed is not working properly
local servers = { 'gopls', 'lemminx', 'jsonls', 'lua_ls', 'jdtls' }


-- see :help mason-lspconfig-introduction
-- mason-lspconfig v2 automatically enables every installed server via
-- `vim.lsp.enable()`, so we no longer wire servers up with `handlers`.
-- jdtls is excluded because we set it up with nvim-jdtls in
-- after/ftplugin/java.lua (auto-enabling it too would double/conflict).
require('mason-lspconfig').setup {
	ensure_installed = servers,

	automatic_enable = {
		exclude = { 'jdtls' },
	},
}
