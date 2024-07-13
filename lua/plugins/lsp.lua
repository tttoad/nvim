return {
	{
		'SirVer/ultisnips',
		dependencies = { 'honza/vim-snippets' },
		config = function() vim.g.UltiSnipsRemoveSelectModeMappings = 0 end,
	},
	{
		'quangnguyen30192/cmp-nvim-ultisnips',
		config = function()
			vim.g.UltiSnipsRemoveSelectModeMappings = 0
		end,
	},
	-- { 'hrsh7th/cmp-nvim-lsp' },
	{ 'hrsh7th/cmp-buffer' },
	{ 'hrsh7th/cmp-path' },
	{ 'hrsh7th/cmp-cmdline' },
	{ 'hrsh7th/nvim-cmp' },
	{ 'neovim/nvim-lspconfig' },
	{ 'fatih/vim-go' },
}
