-- [[ Configure mason ]]

-- mason.setup must always preceed mason-lspconfig.setup
require('mason').setup()

local lspconfig = require('lsp-config')

-- list of nvim-lspconfig servers to install
-- :lua P(require('mason-lspconfig').get_installed_servers())
local servers = { 'gopls', 'lemminx', 'jsonls', 'lua_ls', 'jdtls' }


-- see :help mason-lspconfig-introduction
-- this is approach is preferrable because this will automatically setup server installed 
-- by mason as opposed to installing server first via mason and then setting up them 
-- via nvim-lspconfig
require('mason-lspconfig').setup {
	ensure_installed = servers,

	handlers = {
		-- see :help mason-lspconfig-setup
		lspconfig.default_lsp_handler,

		-- using nvim-jdtls and hence we don't want to setup jdtls using nvim-lspconfig
		['jdtls'] = lspconfig.noop_handler,

		-- customize lua_ls via nvim-lspconfig
		['lua_ls'] = lspconfig.lua_lsp_handler,
	},
}
