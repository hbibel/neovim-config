local M = {}

-- Metals status indicator, e.g. "Indexing"
function M.metals_status()
	return vim.g["metals_status"] or ""
end

function M.attach_lsp(dap)
	-- Let metals show helpful messages
	vim.opt_global.shortmess:remove("F")

	require("metals").setup_dap()
	dap.configurations.scala = {
		{
			type = "scala",
			request = "launch",
			name = "Run file",
			metals = {
				runType = "runOrTestFile",
			},
		},
		{
			type = "scala",
			request = "launch",
			name = "Run with local environment",
			metals = {
				runType = "runOrTestFile",
				envFile = ".env.local",
			},
		},
		{
			type = "scala",
			request = "launch",
			name = "Run or Test",
			metals = {
				runType = "runOrTestFile",
			},
		},
		{
			type = "scala",
			request = "launch",
			name = "Test Target",
			metals = {
				runType = "testTarget",
			},
		}
	}
end

function M.plugins()
	return {
		'scalameta/nvim-metals',
		dependencies = {
			'nvim-lua/plenary.nvim'
		}
	}
end

return M
