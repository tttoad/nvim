require("base.keymap")
require('tree.tree')
require("lsp.lsp")
require("lsp.dap")
require("docker.docker")
require("pls")
local util = require("base.util")
util.keymap("n", "C-l", ":sss")
require('onedark').setup {
	style = 'dark',
}
require('onedark').load()
require('Comment').setup({
	toggler = {
		---Line-comment toggle keymap
		line = '<leader>/',
		---Block-comment toggle keymap
		block = '<leader>.',
	},
	opleader = {
		---Line-comment keymap
		line = '<leader>/',
		---Block-comment keymap
		block = '<leader>.',
	},
})

util.setVimCommand({
	"let g:floaterm_keymap_kill ='<F8>'",
	"let g:floaterm_keymap_new ='<leader>ft'",
	"let g:floaterm_keymap_prev ='<F9>'",
	"let g:floaterm_keymap_next ='<F10>'",
	"let g:floaterm_keymap_toggle ='<F12>'",
	"let g:floaterm_autoclose=v:true"
})

util.keymap("", "<leader>fa", "<cmd>FloatermNew --width=0.8 --height=0.8 <CR>")
util.keymap("", "<leader>lg", "<cmd>FloatermNew --width=3000 --height=3000 lazygit<CR>")

require('nvim-treesitter.install').update({ with_sync = true })
require 'nvim-treesitter.configs'.setup {
	-- a list of parser names, or "all"
	ensure_installed = { "go", "c", "lua", "vim", "vimdoc", "query" },

	highlight = {
		-- `false` will disable the whole extension
		enable = true,
		disable = { "lua" },

		-- setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- using this option may slow down your editor, and you may see some duplicate highlights.
		-- instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},
	rainbow = {
		enable = true,
		-- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
		extended_mode = true, -- also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
		max_file_lines = nil, -- do not enable for files with more than n lines, int
	},
}
require('nvim-treesitter').setup()
