--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('custom.plugins')
require('custom.vimconfigs')

local scala = require('custom.scala')
-- local go = require('custom.go')
local keymaps = require('custom.keymaps')
keymaps.basic()

require('custom.commands').basic()

local lsp = require('custom.lsp')
scala.init(lsp.on_attach)

vim.cmd.colorscheme "catppuccin"
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
