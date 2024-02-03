local M = {}

M.init = function(on_attach)
  table.insert(require("dap").configurations.python,
    {
      name = "Pytest current file",
      type = "python",
      request = "launch",
      module = "pytest",
      args = { "${file}" },
      justMyCode = "false",
      -- ... more options, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
    }
  )
  require("lspconfig").ruff_lsp.setup {
    on_attach = on_attach,
    init_options = {
      settings = {
        -- Any extra CLI arguments for `ruff` go here.
        args = {},
      }
    }
  }
end

return M
