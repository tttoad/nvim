local packer = require('packer')
-- onedark
packer.use('navarasu/onedark.nvim')
require('onedark').setup {
	style = 'cool'
}
require('onedark').load()

-- lualine
packer.use({
	'nvim-lualine/lualine.nvim',
	requires = { 'kyazdani42/nvim-web-devicons', opt = true }
})

require('lualine').setup {
	options = {
		theme = 'onedark'
	}
}

-- -- nvim-bqf
packer.use('kevinhwang91/nvim-bqf')
require('bqf').setup()
--

-- floaterm
packer.use('voldikss/vim-floaterm')
local util = require("base.util")
util.setVimCommand({
	"let g:floaterm_keymap_kill ='<F8>'",
	"let g:floaterm_keymap_new ='<leader>ft'",
	"let g:floaterm_keymap_prev ='<F9>'",
	"let g:floaterm_keymap_next ='<F10>'",
	"let g:floaterm_keymap_toggle ='<F12>'"
})

-- nvim-autopairs
packer.use("windwp/nvim-autopairs")
require("nvim-autopairs").setup({
	disable_filetype = { "TelescopePrompt" },
})


local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
cmp.event:on(
	'confirm_done',
	cmp_autopairs.on_confirm_done()
)

-- vim-translator
packer.use 'voldikss/vim-translator'
util.keymap("n", "<leader>t", "<Plug>TranslateW")
util.keymap("v", "<leader>t", "<Plug>TranslateWV")

-- Comment
packer.use 'numToStr/Comment.nvim'
require('Comment').setup({
	toggler = {
		---Line-comment toggle keymap
		line = '<leader>/',
		---Block-comment toggle keymap
		block = '<leader>.',
	}, opleader = {
		---Line-comment keymap
		line = '<leader>/',
		---Block-comment keymap
		block = '<leader>.',
	},
})

-- tagbar
packer.use 'preservim/tagbar'
util.keymap('', "<F3>", "<cmd> TagbarToggle<CR>")
