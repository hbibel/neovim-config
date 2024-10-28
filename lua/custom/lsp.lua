local on_attach = function(_, bufnr)
  local keymaps = require("custom.keymaps")
  local scala = require("custom.scala")
  local python = require("custom.python")
  local dap = require("dap")
  local commands = require("custom.commands")

  keymaps.lsp(bufnr)

  commands.lsp(bufnr)

  local file_type = vim.bo[bufnr].filetype

  for _, ft in ipairs(scala.file_types) do
    if ft == file_type then
      scala.attach_lsp(dap)
      keymaps.scala(bufnr)
    end
  end

  if file_type == "python" then
    keymaps.python(bufnr)
    python.attach_lsp()
  end
end

local servers = {
  gopls = {
    filetypes = { "go", "gomod", },
  },
  pylsp = {
    settings = {
      pylsp = {
        plugins = {
          -- Using Ruff for linting and formatting, see python.lua
          autopep8 = {
            enabled = false,
          },
          pycodestyle = {
            enabled = false,
          },
        },
      },
    },
  },
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
  rust_analyzer = {},
  ts_ls = {
    filetypes = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
      "html",
    }
  },
  astro = {},
  marksman = {},
  yamlls = {},
  helm_ls = {
    yamlls = {
      path = "yaml-language-server",
    }
  },
  ruff_lsp = {},
}

local setup = function()
  require("neodev").setup()

  -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

  require("mason").setup()

  -- Ensure the servers above are installed
  local mason_lspconfig = require("mason-lspconfig")
  mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers),
  }

  mason_lspconfig.setup_handlers {
    function(server_name)
      require("lspconfig")[server_name].setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = (servers[server_name] or {}).settings,
        filetypes = (servers[server_name] or {}).filetypes,
      }
    end
  }
end

return {
  setup = setup,
  on_attach = on_attach,
}
