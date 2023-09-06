local on_attach = function(_, bufnr)
	local keymaps = require('custom.keymaps')
	local scala = require('custom.scala')
	local dap = require('dap')
	local commands = require('custom.commands')

	keymaps.lsp(bufnr)

	commands.lsp(bufnr)

	local file_type = vim.bo[bufnr].filetype

	for _, ft in ipairs(scala.file_types) do
		if ft == file_type then
			scala.attach_lsp(dap)
			keymaps.scala(bufnr)
		end
	end
end

local servers = {
	gopls = {
		cmd = { 'gopls', '--remote=auto' }
	},
	-- pyright = {},
	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	},
}

local setup = function()
	require('neodev').setup()

	-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

	-- Ensure the servers above are installed
	local mason_lspconfig = require 'mason-lspconfig'

	mason_lspconfig.setup {
		ensure_installed = vim.tbl_keys(servers),
	}

	mason_lspconfig.setup_handlers {
		function(server_name)
			require('lspconfig')[server_name].setup {
				capabilities = capabilities,
				on_attach = on_attach,
				settings = servers[server_name],
				filetypes = (servers[server_name] or {}).filetypes,
			}
		end
	}
end

return {
	setup = setup,
	on_attach = on_attach,
}
