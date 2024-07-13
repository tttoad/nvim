local util = require("base.util")
return {
	{
		'navarasu/onedark.nvim',
		lazy = false,
		config = function()
			require('onedark').setup {
				style = 'cool'
			}
			require('onedark').load()
		end
	},
	{
		'numToStr/Comment.nvim',
		config = function()
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
		end
	},
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' }
	},
	{ 'kevinhwang91/nvim-bqf' },
	{
		'voldikss/vim-floaterm',
		config = function()
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
		end
	},
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({
				disable_filetype = { "TelescopePrompt" },
			})
			local cmp_autopairs = require('nvim-autopairs.completion.cmp')
			local cmp = require('cmp')
			cmp.event:on(
				'confirm_done',
				cmp_autopairs.on_confirm_done()
			)
		end
	},
	{ 'voldikss/vim-translator',
		config = function()
			util.keymap("n", "<leader>t", "<Plug>TranslateW")
			util.keymap("v", "<leader>t", "<Plug>TranslateWV")
		end
	},
	{ 'preservim/tagbar',
		config = function()
			util.keymap('', "<F3>", "<cmd> TagbarToggle<CR>")
		end
	}

}
