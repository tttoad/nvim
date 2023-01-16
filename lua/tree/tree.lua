require('packer').use({
	'kyazdani42/nvim-tree.lua',
	requires = {
		'kyazdani42/nvim-web-devicons', -- optional, for file icons
	},
	tag = 'nightly' -- optional, updated every week. (see issue #1193)
})

local util=require('base.util')

-- nvim-tree
local tree_cb = require 'nvim-tree.config'.nvim_tree_callback
util.keymap("", "<F2>", "<cmd> NvimTreeToggle<cr>")
util.keymap("", "<leader>af", "<cmd> NvimTreeFindFile<cr>")

local function print_node_path(node)
	print(node.absolute_path)
end

require("nvim-tree").setup({
	sort_by = "case_sensitive",
	view = {
		adaptive_size = true,
		mappings = {
			list = {
				{ key = "u", action = "dir_up" },
				{ key = "s", cb = tree_cb("split") },
				{ key = "p", action = "print_path", action_cb = print_node_path },
				{ key = "m", action = "" }
			},
		},
	},
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

