M = {}

-- Comment.nvim predefines
-- [normal mode] `gcc` - Toggles the current line using linewise comment
-- [normal mode] `gbc` - Toggles the current line using blockwise comment
-- [normal mode] `[count]gcc` - Toggles the number of line given as a prefix-count using linewise
-- [normal mode] `[count]gbc` - Toggles the number of line given as a prefix-count using blockwise
-- [normal mode] `gc[count]{motion}` - (Op-pending) Toggles the region using linewise comment
-- [normal mode] `gb[count]{motion}` - (Op-pending) Toggles the region using blockwise comment
-- [visual mode] `gc` - Toggles the region using linewise comment
-- [visual mode] `gb` - Toggles the region using blockwise comment

M.basic = function()
  vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
  vim.keymap.set({ 'n', 'v' }, '<C-e>', '4<C-e><CR>')

  -- Remap for dealing with word wrap
  vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
  vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

  vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
  vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
  vim.keymap.set('n', '<leader>/', function()
    require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      winblend = 10,
      previewer = false,
    })
  end, { desc = '[/] Fuzzily search in current buffer' })

  vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
  vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
  vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
  vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
  vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

  -- Diagnostic keymaps
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
  -- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
  vim.keymap.set('n', '|', '<cmd>Neotree reveal<cr>', { desc = 'Reveal current file in Neotree' })

  vim.keymap.set('n', '<leader>get', require('grapple').tag, { desc = '[G]rappl[e] [T]ag' })
  vim.keymap.set('n', '<leader>geu', require('grapple').untag, { desc = '[G]rappl[e] [U]ntag' })
  vim.keymap.set('n', '<leader>geg', require('grapple').popup_tags, { desc = '[G]rappl[e] [G]o to tag' })
  -- easier navigation out of a terminal
  -- vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], { buffer = 0 })
  -- vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], { buffer = 0 })
  -- vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], { buffer = 0 })
  -- vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], { buffer = 0 })
  -- vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], { buffer = 0 })
  -- vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], { buffer = 0 })
end

function M.lsp(bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>xwo', require('dap').repl.close, '[Close] [W]indow: [O]utput')
  nmap('<leader>owo', require('dap').repl.open, '[Open] [W]indow: [O]utput')

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  nmap('<C-l>', vim.lsp.codelens.run, '[E]xecute [L]ens action')

  nmap("<leader>dc", require("dap").continue)
end

function M.scala(bufnr)
  -- require('telescope.builtin').lsp_references doesn't work in Metals
  -- unfortunately
  vim.keymap.set('n', 'gr', vim.lsp.buf.references,
    { buffer = bufnr, desc = '[G]oto [R]eferences' })
end

return M
