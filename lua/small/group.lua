local packer = require('packer')
packer.use('navarasu/onedark.nvim')
packer.use('numToStr/Comment.nvim')
packer.use({
	'nvim-lualine/lualine.nvim',
	requires = { 'kyazdani42/nvim-web-devicons', opt = true }
})
packer.use('kevinhwang91/nvim-bqf')
packer.use('voldikss/vim-floaterm')
packer.use("windwp/nvim-autopairs")
packer.use('voldikss/vim-translator')
packer.use('preservim/tagbar')

-- onedark
require('onedark').setup {
	style = 'cool'
}
require('onedark').load()

-- lualine

require('lualine').setup {
	options = {
		theme = 'onedark'
	}
}

-- -- nvim-bqf
require('bqf').setup()
--

-- floaterm
-- auto close is not work. https://github.com/neovim/neovim/issues/14061
local util = require("base.util")
util.setVimCommand({
	"let g:floaterm_keymap_kill ='<F8>'",
	"let g:floaterm_keymap_new ='<leader>ft'",
	"let g:floaterm_keymap_prev ='<F9>'",
	"let g:floaterm_keymap_next ='<F10>'",
	"let g:floaterm_keymap_toggle ='<F12>'",
	"let g:floaterm_autoclose=v:true"
})

util.keymap("","<leader>lg","<cmd>FloatermNew --width=3000 --height=3000 lazygit<CR>")

-- nvim-autopairs
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
util.keymap("n", "<leader>t", "<Plug>TranslateW")
util.keymap("v", "<leader>t", "<Plug>TranslateWV")

-- Comment
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
util.keymap('', "<F3>", "<cmd> TagbarToggle<CR>")
