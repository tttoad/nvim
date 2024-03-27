require('packer').use({
	'kyazdani42/nvim-tree.lua',
	requires = {
		'kyazdani42/nvim-web-devicons', -- optional, for file icons
	},
})

local util = require('base.util')

-- nvim-tree
util.keymap("", "<F2>", "<cmd> NvimTreeToggle<cr>")
util.keymap("", "<leader>af", "<cmd> NvimTreeFindFile<cr>")
util.keymap("n", "<leader>mn", require("nvim-tree.api").marks.navigate.next)
util.keymap("n", "<leader>mp", require("nvim-tree.api").marks.navigate.prev)
util.keymap("n", "<leader>ms", require("nvim-tree.api").marks.navigate.select)

local function my_on_attach(bufnr)
	local api = require "nvim-tree.api"

	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end -- default mappings api.config.mappings.default_on_attach(bufnr)

	api.config.mappings.default_on_attach(bufnr)
	local function marksTaggle()
		api.marks.toggle()
		vim.cmd("+1")
	end
	-- custom mappings
	vim.keymap.set('n', 'u', api.tree.change_root_to_parent, opts("Up"))
	vim.keymap.set('n', 's', api.node.open.horizontal, opts("Open: Horizontal Split"))
	vim.keymap.set('n', '<space>', marksTaggle, opts("Toggle Bookmark"))
	vim.keymap.set('n', 'm', ":+10 <cr>", opts("Next 10 rows"))
end

require("nvim-tree").setup({
	on_attach = my_on_attach,
	renderer = {
		group_empty = false,
		icons = {
			glyphs = {
				folder = {
					arrow_closed = " ",
					arrow_open = " ",
				},
			},
		},
	},
	git = {
		enable = true,
		ignore = false,
		show_on_dirs = true,
		timeout = 400,
	},
	filters = {
		dotfiles = true,
	},
})
