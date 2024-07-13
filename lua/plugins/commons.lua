local util = require("base.util")
return {
	{
		'crusj/hierarchy-tree-go.nvim',
		dependencies = 'neovim/nvim-lspconfig'
	},
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim"
		},
	},
	-- { 'michaelb/sniprun', build = 'bash ./install.sh' },
	{
		"rcarriga/vim-ultest",
		dependencies = { "vim-test/vim-test" },
		build = ':UpdateRemotePlugins',
	},
	{
		'nvim-treesitter/nvim-treesitter',
	},
	{
		'lewis6991/gitsigns.nvim',
		opt = {
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map('n', ']c', function()
					if vim.wo.diff then return ']c' end
					vim.schedule(function() gs.next_hunk() end)
					return '<Ignore>'
				end, { expr = true })

				map('n', '[c', function()
					if vim.wo.diff then return '[c' end
					vim.schedule(function() gs.prev_hunk() end)
					return '<Ignore>'
				end, { expr = true })

				-- Actions
				map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>')
				map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')
				-- map('n', '<leader>hS', gs.stage_buffe)
				map('n', '<leader>hu', gs.undo_stage_hunk)
				map('n', '<leader>hR', gs.reset_buffer)
				map('n', '<leader>hp', gs.preview_hunk)
				map('n', '<leader>hb', function() gs.blame_line { full = true } end)
				map('n', '<leader>tb', gs.toggle_current_line_blame)
				map('n', '<leader>hd', gs.diffthis)
				map('n', '<leader>hD', function() gs.diffthis('~') end)
				-- map('n', '<leader>td', gs.toggle_deleted)

				-- Text object
				map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
			end
		}
	},

	{ 'p00f/nvim-ts-rainbow' },

	{
		'mbbill/undotree',
		config = function()
			util.keymap("n", "<leader>hh", "<cmd>UndotreeToggle<cr>")
			vim.cmd(
				[[
func SetUndodir()
	if has("persistent_undo")
		let target_path = expand('~/.undodir')

		" " create the directory and any parent directories
		" " if the location does not exist.
		if !isdirectory(target_path)
			call mkdir(target_path, "p", 0700)
		endif

		let &undodir=target_path
		set undofile
	endif
endfunc
call SetUndodir()
]]
			)
		end
	},

	-- markdown
	{ 'iamcco/markdown-preview.nvim' },

	-- search
	{
		'nvim-telescope/telescope.nvim', tag = '0.1.5',
		-- or                            , branch = '0.1.x',
		dependencies = { { 'nvim-lua/plenary.nvim' } },
	},
	{
		'nvim-telescope/telescope-fzf-native.nvim',
		build = 'make',
		config = function()
			local telescope = require('telescope')
			telescope.setup {
				extensions = {
					fzf = {
						fuzzy = true, -- false will only do exact matching
						override_generic_sorter = true, -- override the generic sorter
						override_file_sorter = true, -- override the file sorter
						case_mode = "smart_case", -- or "ignore_case" or "respect_case"
						-- the default case_mode is "smart_case"
					}
				}
			}

			telescope.load_extension('fzf')

			util.keymap('n', '<leader>ff', '<cmd>Telescope find_files<CR>')
			util.keymap('n', '<leader>fg', '<cmd>Telescope live_grep<CR>')
			util.keymap('n', '<leader>fb', '<cmd>Telescope buffer<CR>')
			util.keymap('n', '<leader>fh', '<cmd>Telescope help_tags<CR>')
			util.keymap('n', '<leader>fz', '<cmd>Telescope grep_string search= <CR>')
		end
	},
	-- vim.opt.completeopt = { "menu", "menuone", "noselect" },
}
