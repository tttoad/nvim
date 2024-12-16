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

util.keymap("", "<leader>fa", "<cmd>FloatermNew --width=0.8 --height=0.8 <CR>")
util.keymap("", "<leader>lg", "<cmd>FloatermNew --width=3000 --height=3000 lazygit<CR>")
util.keymap("", "<c-q>", function()
	util.cmd("FloatermKill !")
	util.cmd("wqa")
end)

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
	},
	opleader = {
		---Line-comment keymap
		line = '<leader>/',
		---Block-comment keymap
		block = '<leader>.',
	},
})

-- tagbar
-- util.keymap('', "<F3>", "<cmd> TagbarToggle<CR>")

-- gotags
require"structrue-go".setup({
	keymap = {
		toggle = "<F3>", -- toggle structure-go window
		show_others_method_toggle = "H", -- show or hidden the methods of struct whose not in current file
		symbol_jump = "<CR>", -- jump to then symbol file under cursor
		center_symbol = "\\f", -- Center the highlighted symbol
		fold_toggle = "\\z",
		refresh = "R", -- refresh symbols
		preview_open = "P", -- preview  symbol context open
		preview_close = "\\p" -- preview  symbol context close
	}
}
)
