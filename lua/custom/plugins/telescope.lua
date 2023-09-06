local setup = function()
	require('telescope').setup {
		defaults = {
			mappings = {
				i = {
					['<C-u>'] = false,
					['<C-d>'] = false,
				},
			},
			file_ignore_patterns = { 'node_modules', 'target', '.git' },
		},
	}

	pcall(require('telescope').load_extension, 'fzf')
end

return {
	setup = setup,
}
