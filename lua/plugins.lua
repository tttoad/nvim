require('packer').startup(function()

	use 'wbthomason/packer.nvim'
	use "morhetz/gruvbox"

	-- For ultisnips users.
	use { 'michaelb/sniprun', run = 'bash ./install.sh' }

	use {
		"nvim-neotest/neotest",
		requires = {
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim"
		}
	}
	use { "rcarriga/vim-ultest", requires = { "vim-test/vim-test" }, run = ":UpdateRemotePlugins" }

	use {
		'nvim-treesitter/nvim-treesitter',
		run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
	}

	use {
		'lewis6991/gitsigns.nvim',
		-- tag = 'release' -- To use the latest release (do not use this if you run Neovim nightly or dev builds!)
	}	

	use 'p00f/nvim-ts-rainbow'

	use 'mbbill/undotree'

	-- markdown
	use 'iamcco/markdown-preview.nvim'

	-- search
	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.0',
		-- or                            , branch = '0.1.x',
		requires = { { 'nvim-lua/plenary.nvim' } }
	}
	use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

	vim.opt.completeopt = { "menu", "menuone", "noselect" }
end)


local util = require("base.util")

-- load plugin
require("tree.tree")
require("base.keymap")
require("lsp.lsp")
require("lsp.dap")
require("small.group")



-- nvim-treesitter
require 'nvim-treesitter.configs'.setup {
	-- A list of parser names, or "all"
	ensure_installed = { "go", "c" },

	highlight = {
		-- `false` will disable the whole extension
		enable = true,
		disable = { "lua" },

		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},
	rainbow = {
		enable = true,
		-- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
		extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
		max_file_lines = nil, -- Do not enable for files with more than n lines, int
	},
}
--
-- gitsigns
require('gitsigns').setup({
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
})

-- undotree
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

-- markdown
-- keymap('n','<C-p>','<Plug>MarkdownPreviewToggle')
-- nmap <C-s> <Plug>MarkdownPreview

-- nmap <M-s> <Plug>MarkdownPreviewStop
-- nmap <C-p> <Plug>MarkdownPreviewToggle
-- telescope
--
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
-- nnoremap <leader>fb <cmd>Telescope buffers<cr>
-- nnoremap <leader>fh <cmd>Telescope help_tags<cr>

-- nvim-test
util.keymap("n", "<leader>tr", "<cmd>UltestSummary<cr>")
util.keymap("n", "<leader>td", "<cmd>UltestDebug<cr>")
util.cmd("let g:ultest_deprecation_notice = 0")

local ultest = require 'ultest'

ultest.setup({
	builders = {
		["go#gotest"] = function(cmds)
			local args = {}
			for i = 3, #cmds - 1, 1 do
				local arg = args[i]
				if vim.startswith(arg, "-") then
					arg = "-test." .. string.sub(arg, 2)
				end
				args[#args + 1] = arg
			end

			local mode = vim.fn.inputlist({
				'Select the debugging mode for unit tests:',
				'(1):local mode.',
				'(2):remote mode.',
				'(3):others use local mode.'
			})

			if (mode ~= 2)
			then
				return {
					dap = {
						type = 'go',
						name = 'Debug test',
						request = 'launch',
						mode = 'test',
						showLog = false,
						program = "./${relativeFileDirname}",
						args = args,
					},
					parse_result = function(lines)
						return lines[#lines] == "FAIL" and 1 or 0
					end
				}
			else
				return {
					dap = {
						type = 'delve',
						name = 'Debug test',
						request = 'launch',
						mode = 'test',
						showLog = false,
						program = function()
							return vim.fn.input('Program: ')
						end,
						outputMode = 'remote',
						substitutePath = {
							{
								from = "/Users/toad/work",
								to = "/root",
							}
						},
						args = args,
					},
					parse_result = function(lines)
						return lines[#lines] == "FAIL" and 1 or 0
					end
				}
			end
		end
	}
})

-- sniprun
util.keymap("", "<leader>rr", "<cmd>SnipRun<CR>")
require 'sniprun'.setup({
	selected_interpreters = {}, --# use those instead of the default for the current filetype
	repl_enable = {}, --# enable REPL-like behavior for the given interpreters
	repl_disable = {}, --# disable REPL-like behavior for the given interpreters
	interpreter_options = { --# interpreter-specific options, see docs / :SnipInfo <name>

		--# use the interpreter name as key
		GFM_original = {
			use_on_filetypes = { "markdown.pandoc" } --# the 'use_on_filetypes' configuration key is
			--# available for every interpreter
		},
		Python3_original = {
			error_truncate = "auto" --# Truncate runtime errors 'long', 'short' or 'auto'
			--# the hint is available for every interpreter
			--# but may not be always respected
		}
	},
	--# you can combo different display modes as desired
	display = {
		"Classic", --# display results in the command-line  area
		-- "VirtualTextOk",              --# display ok results as virtual text (multiline is shortened)

		-- "VirtualTextErr",          --# display error results as virtual text
		-- "TempFloatingWindow",      --# display results in a floating window
		-- "LongTempFloatingWindow",  --# same as above, but only long results. To use with VirtualText__
		"Terminal", --# display results in a vertical split
		-- "TerminalWithCode",        --# display results and code history in a vertical split
		-- "NvimNotify",              --# display with the nvim-notify plugin
		-- "Api"                      --# return output to a programming interface
	},
	display_options = {
		terminal_width = 45, --# change the terminal display option width
		notification_timeout = 5 --# timeout for nvim_notify output
	},
	--# You can use the same keys to customize whether a sniprun producing
	--# no output should display nothing or '(no output)'
	show_no_output = {
		"Classic",
		"TempFloatingWindow", --# implies LongTempFloatingWindow, which has no effect on its own
	},
	--# customize highlight groups (setting this overrides colorscheme)
	snipruncolors = {
		SniprunVirtualTextOk  = { bg = "#66eeff", fg = "#000000", ctermbg = "Cyan", cterfg = "Black" },
		SniprunFloatingWinOk  = { fg = "#66eeff", ctermfg = "Cyan" },
		SniprunVirtualTextErr = { bg = "#881515", fg = "#000000", ctermbg = "DarkRed", cterfg = "Black" },
		SniprunFloatingWinErr = { fg = "#881515", ctermfg = "DarkRed" },
	},
	--# miscellaneous compatibility/adjustement settings
	inline_messages = 0, --# inline_message (0/1) is a one-line way to display messages
	--# to workaround sniprun not being able to display anything

	borders = 'single', --# display borders around floating windows
	--# possible values are 'none', 'single', 'double', or 'shadow'
	live_mode_toggle = 'off' --# live mode toggle, see Usage - Running for more info
})

-- ultisnips
util.cmd('let g:UltiSnipsExpandTrigger="<CR>"')
util.cmd('let g:UltiSnipsJumpForwardTrigger="<c-b>"')
util.cmd('let g:UltiSnipsJumpBackwardTrigger="<c-z>"')

return
