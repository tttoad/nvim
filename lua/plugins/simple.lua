local util = require("base.util")
return {
	{
		"morhetz/gruvbox",
	},
	{
		'navarasu/onedark.nvim',
		config = function()
			require('onedark').setup {
				style = 'dark',
			}
			require('onedark').load()
		end,
		priority = 1000,
	},
	{
		'numToStr/Comment.nvim'
	},
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' }
	},
	{ 'kevinhwang91/nvim-bqf' },
	{
		'voldikss/vim-floaterm'
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
