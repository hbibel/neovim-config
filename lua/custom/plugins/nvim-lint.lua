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

    --- Find a binary in the node_modules of any parent of the current buffer
    --- @param cmd string
    --- @return string | nil
    local function find_node_modules_binary(cmd)
      local current_file = vim.api.nvim_buf_get_name(0)
      local current_dir = vim.fn.fnamemodify(current_file, ":h")

      while current_dir ~= "/" do
        local binary_path = current_dir .. "/node_modules/.bin/" .. cmd
        if vim.uv.fs_stat(binary_path) then
          return vim.fn.fnamemodify(binary_path, ":p")
        end
        current_dir = vim.fn.fnamemodify(current_dir, ":h")
      end
      return nil
    end

    local xo_bin = find_node_modules_binary("xo")
    if xo_bin then
      nvim_lint.linters.eslint.cmd = xo_bin
      nvim_lint.linters.eslint.args = {
        "--reporter",
        "json",
        "--stdin",
        "--stdin-filename",
        function() return vim.api.nvim_buf_get_name(0) end,
      }
    else
      local binary_name = "eslint"
      local eslint = find_node_modules_binary(binary_name)
      nvim_lint.linters.eslint.cmd = eslint or binary_name
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
