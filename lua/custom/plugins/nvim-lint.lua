return {
  setup = function()
    local nvim_lint = require("lint")

    local python_linters = {}

    local mypy_cmd = require("custom.python").get_mypy_command()
    if mypy_cmd ~= nil then
      nvim_lint.linters.mypy.cmd = mypy_cmd[1]
      nvim_lint.linters.mypy.args = { unpack(mypy_cmd, 2) }

      table.insert(python_linters, "mypy")
    end

    if vim.fn.filereadable("./node_modules/.bin/xo") == 1 then
      -- Note: nvim-lint defines a function for cmd which determines whether
      -- eslint is installed globally or in node_modules, but I don't install
      -- it globally, so I don't need that.
      nvim_lint.linters.eslint.cmd = vim.fn.fnamemodify('./node_modules/.bin/xo', ':p')
      nvim_lint.linters.eslint.args = {
        '--reporter',
        'json',
        '--stdin',
        '--stdin-filename',
        function() return vim.api.nvim_buf_get_name(0) end,
      }
    end

    nvim_lint.linters_by_ft = {
      python = python_linters,
      typescript = { "eslint", }
    }

    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })
  end,
}
