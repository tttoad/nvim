return {
	{
		'kyazdani42/nvim-tree.lua',
		dependencies = {
			'kyazdani42/nvim-web-devicons', -- optional, for file icons
		},
		config = function()
			require('tree.tree')
		end,
	},
}
