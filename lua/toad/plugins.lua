require('packer').startup(function()
	use 'wbthomason/packer.nvim'
	use "navarasu/onedark.nvim"
	use "morhetz/gruvbox"
	use { 'kevinhwang91/nvim-bqf' }
	use {
		'kyazdani42/nvim-tree.lua',
		requires = {
			'kyazdani42/nvim-web-devicons', -- optional, for file icons
		},
		tag = 'nightly' -- optional, updated every week. (see issue #1193)
	}
	use "windwp/nvim-autopairs"
	use 'preservim/tagbar'

	use 'fatih/vim-go'

	use 'neovim/nvim-lspconfig'
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-path'
	use 'hrsh7th/cmp-cmdline'
	use 'hrsh7th/nvim-cmp'
	-- For ultisnips users.
	use { 'SirVer/ultisnips', requires = 'honza/vim-snippets',
		config = function() vim.g.UltiSnipsRemoveSelectModeMappings = 0 end, }
	use { 'quangnguyen30192/cmp-nvim-ultisnips',
		config = function() vim.g.UltiSnipsRemoveSelectModeMappings = 0 end, }
	use { 'michaelb/sniprun', run = 'bash ./install.sh' }

	use 'voldikss/vim-floaterm'

	use {
		"nvim-neotest/neotest",
		requires = {
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim"
		}
	}
	use { "rcarriga/vim-ultest", requires = { "vim-test/vim-test" }, run = ":UpdateRemotePlugins" }
	-- lualine
	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'kyazdani42/nvim-web-devicons', opt = true }
	}

	use {
		'nvim-treesitter/nvim-treesitter',
		run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
	}
	-- debug
	use 'ravenxrz/DAPInstall.nvim'
	use 'mfussenegger/nvim-dap'
	use 'theHamsta/nvim-dap-virtual-text'
	use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } }


	use {
		'lewis6991/gitsigns.nvim',
		-- tag = 'release' -- To use the latest release (do not use this if you run Neovim nightly or dev builds!)
	}

	use 'p00f/nvim-ts-rainbow'

	use 'mbbill/undotree'

	-- markdown
	use 'iamcco/markdown-preview.nvim'

	use 'numToStr/Comment.nvim'

	use 'voldikss/vim-translator'

	-- search
	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.0',
		-- or                            , branch = '0.1.x',
		requires = { { 'nvim-lua/plenary.nvim' } }
	}
	use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

	vim.opt.completeopt = { "menu", "menuone", "noselect" }
end)

--- custom keymap

local function cmd(cmdStr)
	vim.api.nvim_command(cmdStr)
end

local function setVimCommand(cmds)
	for _, c in pairs(cmds) do
		cmd(c)
	end
end

setVimCommand({
	'set number',
	'set ignorecase',
	'set encoding=UTF-8',
	-- 'set number',
	--set lines=60
	--set columns=200
	'set mouse=a',
	'syntax on',
	'set cursorline',
	'set laststatus=2',
	--set autoindent',
	'set tabstop=4',
	'set smarttab',
	'set shiftwidth=4',
	'set softtabstop=4',
	'set backspace=eol,start,indent',

	'set showcmd',
	'set whichwrap+=<,>,h,l',
	'set scrolloff=3',
	'set history=1000',
	'set nobackup',
	'set nocompatible',
	-- set verbosefile=./vim.log',
	'set cmdheight=2',
	-- 'set completeopt-=preview',
	'set completeopt=menu,menuone,noselect',
	'set signcolumn=yes',
	'set autowriteall',

	':autocmd InsertEnter * set cul',
	':autocmd InsertLeave * set nocul'

})

local function split(str, reps)
	local resultStrList = {}
	_ = string.gsub(str, '[^' .. reps .. ']+', function(w)
		table.insert(resultStrList, w)
	end)
	return resultStrList
end

local function keymap(model, key, val)
	vim.keymap.set(model, key, val)
end

local function setVimKeyMap(keyMap)
	for _, val in pairs(keyMap) do
		local args = split(val, " ")
		local model = string.sub(args[1], 1, 1)

		if (model == 'm') then
			model = ''
		end

		keymap(model, args[2], args[3])
	end
end

setVimKeyMap({
	'nnoremap m :+10<cr>',
	'nnoremap , :-10<cr>',
	'vnoremap m 10<cr>',
	'vnoremap , 10-',
	'imap <c-k> <up>',
	'imap <c-h> <left>',
	'imap <c-j> <down>',
	'imap <c-l> <right>',
	'imap <c-a> <esc>I',
	'nmap <c-a> ^',
	'vnoremap <c-a> ^',
	'inoremap <c-e> <esc>A',
	'nnoremap <c-e> $',
	'vnoremap <c-e> $',
	'imap <c-g> <esc>GG',
	'imap <c-o> <esc>o',
	'imap <c-u> <esc>u',
	'imap <c-d> <esc>ddi',
	'nmap <c-k> <up>',
	'nmap <c-h> <left>',
	'nmap <c-j> <down>',
	'nmap <c-l> <right>',
	'inoremap <c-t> <esc>yyi',
	'nnoremap <c-t> <c-o>',
	'imap <c-p> <esc>pi',
	'nnoremap <c-G> GG',
	'imap <c-G> <esc>GG',
	'imap <c-s> <esc>:w<cr>',
	'nmap <c-s> :w<cr>',
	'nmap <c-q> :wqa<cr>',
	'imap <c-q> :wqa<cr>',
	'nmap L $',
	'nmap H ^',
	-- 'noremap <c-w> <c-w>w',
	'vmap <leader>y "+y',
	'vnoremap <c-d> "+d',
	'nmap <leader>v "+p',
	'noremap <c-x> <c-r>',
	'map <C-n> :cnext<CR>',
	'map <C-m> :cprevious<CR>',
})

-- vim-go
keymap('', "<F1>", ":GoDocBrowser<CR>")
keymap('n', "<leader><space>i", ":GoImpl ")
keymap('n', "<leader>fill", ":GoFillStruct<CR>")
keymap('n', "<leader>f", ":GoReferrers<CR>")
keymap('n', "<leader>c", ":GoCallees<CR>")
keymap('n', "<leader>tg", ":GoAddTags<CR>")

-- nvim-cmp
require("cmp_nvim_ultisnips").setup {}


local cmp = require('cmp')
local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")
--
cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
		end,
	},
	preselect = cmp.PreselectMode.None,
	mapping = {
		['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently used item. Set `select` to `false` to only confirm explicitly selected items.
		["<c-n>"] = cmp.mapping(function(fallback)
			if vim.fn["UltiSnips#CanJumpForwards"] then
				cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
			end
		end, { "i" }),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
			end
		end, { "i", "s" }),
		['<C-Space>'] = cmp.mapping.complete(),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			cmp_ultisnips_mappings.jump_backwards(fallback)
		end, { "i", "s" }),
	},

	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'ultisnips' },
		{ name = 'path' }
	}, {
		{ name = 'buffer' },
	}),
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	}
})

-- local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()) --nvim-cmp
-- capabilities.textDocument.completion.completionItem.snippetSupport = true

local on_attach = function(_, bufnr)
	-- local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

	local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

	buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
end

-- close quickfix
keymap("", "<leader>a", ":cclose<CR>")

-- Setup lspconfig.
local nvim_lsp = require('lspconfig')

-- setup languages
-- GoLang
nvim_lsp['gopls'].setup {
	cmd = { 'gopls' },
	on_attach = on_attach,
	--	capabilities = capabilities,
	settings = {
		gopls = {
			experimentalPostfixCompletions = true,
			analyses = {
				unusedparams = true,
				shadow = true,
			},
			staticcheck = false,
		},
	},
	init_options = {
		usePlaceholders = true,
	}
}

-- order imports
function Go_org_imports(wait_ms)
	local params = vim.lsp.util.make_range_params()
	params.context = { only = { "source.organizeImports" } }
	local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
	for cid, res in pairs(result or {}) do
		for _, r in pairs(res.result or {}) do
			if r.edit then
				local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
				vim.lsp.util.apply_workspace_edit(r.edit, enc)
			end
		end
	end
end

cmd("autocmd BufWritePre *.go lua Go_org_imports()")
--
-- lua
nvim_lsp['sumneko_lua'].setup {
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = 'LuaJIT',
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { 'vim' },
				workspaceDelay = -1,
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
}

-- lsp-config

local bufopts = { noremap = true, silent = true, buffer = bufnr }
local opts = { noremap = true, silent = true }
-- vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
-- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
-- vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
-- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
-- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
-- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
--[[ vim.keymap.set('n', '<space>wl', function() ]]
--[[ print(vim.inspect(vim.lsp.buf.list_workspace_folders())) ]]
--[[ end, bufopts) ]]
vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
vim.keymap.set('', '<leader>rn', vim.lsp.buf.rename, bufopts)
vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
vim.keymap.set('', '<C-R>', vim.lsp.buf.formatting, bufopts)

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
	sources = cmp.config.sources({
		{ name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
	}, {
		{ name = 'buffer' },
	})
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' }
	}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	})
})

-- nvim-tree
local tree_cb = require 'nvim-tree.config'.nvim_tree_callback
keymap("", "<F2>", "<cmd> NvimTreeToggle<cr>")
keymap("", "<leader>af", "<cmd> NvimTreeFindFile<cr>")

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

local dap = require('dap')
function closeDebug()
	require 'dap'.close()
	require 'dapui'.close({})
	require 'nvim-dap-virtual-text'.disable()
end

keymap("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>")
keymap("n", "<leader>dt", "<cmd>lua require'dap'.terminate()<CR>")
keymap("n", "<leader>ds", "<cmd>lua closeDebug()<CR>")
keymap("n", "<leader>dc", "<cmd>lua require'dap'.continue()<CR>")
keymap("n", "<leader>dlb", "<cmd>lua require'dap'.list_breakpoints()<CR>")
keymap("n", "<leader>dcb", "<cmd>lua require'dap'.clear_breakpoints()<CR>")
keymap("n", "<F5>", "<cmd>lua require'dap'.step_over()<CR>")
keymap("n", "<F6>", "<cmd>lua require'dap'.step_into()<CR>")
keymap("n", "<F7>", "<cmd>lua require'dap'.step_out()<CR>")
keymap("n", "<leader>dg", "<cmd>lua require'dap'.run_to_cursor()<CR>")
keymap("n", "<leader>re", "<cmd>lua require'dap'.repl.toggle()<CR>")

dap.adapters.go = {
	type = 'server',
	port = '${port}',
	executable = {
		command = 'dlv',
		args = { 'dap', '-l', '127.0.0.1:${port}' },
	}
}

-- require('dap.ext.vscode').load_launchjs(nil, { go = { 'go' } })

-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
-- dap.configurations.go = {
-- 	{
-- 		type = "delve",
-- 		name = "Debug",
-- 		request = "launch",
-- 		program = "${file}"
-- 	},
-- 	{
-- 		type = "delve",
-- 		name = "Debug test", -- configuration for debugging test files
-- 		request = "launch",
-- 		mode = "test",
-- 		program = "${file}"
-- 	},
-- 	-- works with go.mod packages and sub packages
-- 	{
-- 		type = "delve",
-- 		name = "Debug test (go.mod)",
-- 		request = "launch",
-- 		mode = "test",
-- 		program = "./${relativeFileDirname}"
-- 	}
-- }
--
-- dap.adapters.go = {
-- 	type = 'executable';
-- 	command = 'node';
-- 	args = {'../vscode-go/dist/debugAdapter.js' };
-- }

-- parse args
local function splitArgs(args)
	local nextIndex = 0
	local result = {}

	for i = 1, #args do
		local c = args:sub(i, i)
		if i < nextIndex then
			goto continue
		end

		if c ~= ' ' then
			local find = false
			for j = i, #args do
				local cc = args:sub(j, j)
				if j >= nextIndex then
					if cc == '\"' then
						local ends = args:find("\"", j + 1)
						if ends == nil then
							ends = args:len() - 1
						end

						nextIndex = ends + 1
					else if cc == " " then
							nextIndex = j
							find = true
							break
						end
					end
				end
			end

			if not find then
				nextIndex = args:len() + 1
			end

			if c == "\"" then
				table.insert(result, args:sub(i + 1, nextIndex - 2))
			else
				table.insert(result, args:sub(i, nextIndex - 1))
			end

			goto continue
		end
		::continue::
	end

	return result
end

dap.set_log_level('TRACE')
dap.configurations.go = {
	{
		type = 'go';
		name = 'Debug';
		request = 'launch';
		-- showLog = true;
		program = "${file}";
		-- dlvToolPath = vim.fn.exepath('dlv');  -- Adjust to where delve is installed
	},
	{
		type = 'go';
		name = 'Debug-args';
		request = 'launch';
		-- showLog = true;
		program = "${file}";
		-- dlvToolPath = vim.fn.exepath('dlv');  -- Adjust to where delve is installed
		args = function()
			local args_string = vim.fn.input('Arguments: ')
			return vim.split(args_string, " +")
		end;
	},

	{
		type = 'go';
		name = 'workspace-args';
		request = 'launch';
		-- showLog = true;
		program = "${workspaceFolder}";
		-- dlvToolPath = vim.fn.exepath('dlv');  -- Adjust to where delve is installed
		args = function()
			local args_string = vim.fn.input('Arguments: ')
			-- return vim.split(args_string, " +")
			return splitArgs(args_string)
		end;
	},
	{
		type = 'delve';
		name = 'remote';
		request = 'launch';
		mode = "debug";
		-- showLog = true;
		program = function()
			return vim.fn.input('Program: ')
		end;
		args = function()
			local args_string = vim.fn.input('Arguments: ')
			-- return vim.split(args_string, " +")
			return splitArgs(args_string)
		end
	}
}

-- TODO ????????????????????????
dap.adapters.delve = function(cb, config)
	local host = vim.fn.input('host:')
	local port = vim.fn.input('port:')
	cb({
		type = 'server',
		host = host,
		port = port,
	})
end

--
-- dap.configurations.go = {
-- 	{
-- 		type = 'go';
-- 		name = 'Debug';
-- 		request = 'launch';
-- 		showLog = false;
-- 		program = "${file}";
-- 		dlvToolPath = vim.fn.exepath('dlv') -- Adjust to where delve is installed
-- 	},
-- }

-- nvim-dap-virtual-text
require("nvim-dap-virtual-text").setup({
	enabled = true, -- enable this plugin (the default)
	enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
	highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
	highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
	show_stop_reason = true, -- show stop reason when stopped for exceptions
	commented = false, -- prefix virtual text with comment string
	only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
	all_references = false, -- show virtual text on all all references of the variable (not only definitions)
	filter_references_pattern = '<module', -- filter references (not definitions) pattern when all_references is activated (Lua gmatch pattern, default filters out Python modules)
})

-- dap-ui

keymap('n', "<leader>k", "<cmd>lua require'dapui'.eval()<CR>")

local dapui = require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open({ reset = true })
	cmd("DapVirtualTextEnable")
end
dap.listeners.after.event_terminated["dapui_config"] = function()
	-- dapui.close({})
	cmd("DapVirtualTextDisable")
end
dap.listeners.after.event_exited["dapui_config"] = function()
	-- dapui.close({})
	cmd("DapVirtualTextDisable")
end

dapui.setup()
-- -- DAPInstall
--
-- local dap_install = require("dap-install")
--
-- dap_install.setup({
-- 	installation_path = vim.fn.stdpath("data") .. "/dapinstall/",
-- })
--
-- dap_install.config("go", {})
--- debug end

--

-- tagbar
keymap('', "<F3>", "<cmd> TagbarToggle<CR>")
--
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
keymap("n", "<leader>hh", "<cmd>UndotreeToggle<cr>")
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
-- nvim-autopairs
require("nvim-autopairs").setup({
	disable_filetype = { "TelescopePrompt" },
})

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
	'confirm_done',
	cmp_autopairs.on_confirm_done()
)

-- vim-translator
keymap("n", "<leader>t", "<Plug>TranslateW")
keymap("v", "<leader>t", "<Plug>TranslateWV")

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

keymap('n', '<leader>ff', '<cmd>Telescope find_files<CR>')
keymap('n', '<leader>fg', '<cmd>Telescope live_grep<CR>')
keymap('n', '<leader>fb', '<cmd>Telescope buffer<CR>')
keymap('n', '<leader>fh', '<cmd>Telescope help_tags<CR>')
keymap('n', '<leader>fz', '<cmd>Telescope grep_string search= <CR>')
-- nnoremap <leader>fb <cmd>Telescope buffers<cr>
-- nnoremap <leader>fh <cmd>Telescope help_tags<cr>

-- -- nvim-bqf
require('bqf').setup()
--
-- nvim-test
keymap("n", "<leader>tr", "<cmd>UltestSummary<cr>")
keymap("n", "<leader>td", "<cmd>UltestDebug<cr>")
cmd("let g:ultest_deprecation_notice = 0")

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
			return {
				dap = {
					type = 'go';
					name = 'Debug test';
					request = 'launch';
					mode = 'test';
					showLog = false;
					program = "./${relativeFileDirname}";
					args = args;
				},
				parse_result = function(lines)
					return lines[#lines] == "FAIL" and 1 or 0
				end
			}
		end
	}
})

-- sniprun
keymap("", "<leader>rr", "<cmd>SnipRun<CR>")
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
cmd('let g:UltiSnipsExpandTrigger="<CR>"')
cmd('let g:UltiSnipsJumpForwardTrigger="<c-b>"')
cmd('let g:UltiSnipsJumpBackwardTrigger="<c-z>"')

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

-- floaterm
-- map <leader>n <esc>:FloatermNew lf<CR>
-- map <leader>ftr :FloatermNew --height=0.3 --wintype=split --position=right <CR>
--
setVimCommand({
	"let g:floaterm_keymap_kill ='<F8>'",
	"let g:floaterm_keymap_new ='<leader>ft'",
	"let g:floaterm_keymap_prev ='<F9>'",
	"let g:floaterm_keymap_next ='<F10>'",
	"let g:floaterm_keymap_toggle ='<F12>'"
})

-- jsonnet
require 'lspconfig'.jsonnet_ls.setup {
	ext_vars = {
		foo = 'bar',
	},
	formatting = {
		-- default values
		Indent              = 2,
		MaxBlankLines       = 2,
		StringStyle         = 'single',
		CommentStyle        = 'slash',
		PrettyFieldNames    = true,
		PadArrays           = false,
		PadObjects          = true,
		SortImports         = true,
		UseImplicitPlus     = true,
		StripEverything     = false,
		StripComments       = false,
		StripAllButComments = false,
	},
}

-- josn
--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

require 'lspconfig'.jsonls.setup {
	capabilities = capabilities,
}

-- clang
require 'lspconfig'.clangd.setup {}

return
