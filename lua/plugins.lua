local log = require("base.log")
vim.g.opencode_opts = {
  lsp = { enable = true }
}

require('packer').startup(function()
	use 'wbthomason/packer.nvim'
	use "morhetz/gruvbox"

	-- For ultisnips users.
	use { 'michaelb/sniprun', run = 'bash ./install.sh' }

	use {
		'crusj/hierarchy-tree-go.nvim',
		requires = 'neovim/nvim-lspconfig'
	}

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

	-- use 'p00f/nvim-ts-rainbow'

	use 'mbbill/undotree'

	-- markdown
	use 'iamcco/markdown-preview.nvim'

	-- search
	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.5',
		-- or                            , branch = '0.1.x',
		requires = { { 'nvim-lua/plenary.nvim' } }
	}
	use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }


	-- Required plugins
	use {
		"ravitemer/mcphub.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("mcphub").setup({
				use_bundled_binary = false, -- Use local `mcp-hub` binary
				cmd = "mcp-hub",
			})
		end,
	}
	-- Optional dependencies
	use 'hrsh7th/nvim-cmp'
	use 'nvim-tree/nvim-web-devicons' -- or use 'echasnovski/mini.icons'
	-- use 'zbirenbaum/copilot.lua'

	use 'mfussenegger/nvim-jdtls'
	use 'stevearc/dressing.nvim'

	-- Avante.nvim with build process
	use 'nvim-lua/plenary.nvim'
	use 'MunifTanjim/nui.nvim'
	use 'MeanderingProgrammer/render-markdown.nvim'
	use {
		'yetone/avante.nvim',
		-- branch = 'main',
		-- tags = "v0.0.19",
		run = 'make',
	}
	use {
		"nickjvandyke/opencode.nvim",
		tag = "*", -- 对应 lazy 的 version = "*"
		requires = {
			-- packer 中 dependencies 对应 requires
			{ "folke/snacks.nvim" },
		},
		config = function()
			-- 1. 配置 Snacks.nvim (如果需要自定义)
			require("snacks").setup({
				input = { enabled = true }, -- 开启输入增强
				picker = {
					enabled = true,
					actions = {
						opencode_send = function(...) return require("opencode").snacks_picker_send(...) end,
					},
					win = {
						input = {
							keys = {
								["<leader>o"] = { "opencode_send", mode = { "n", "i" } },
							},
						},
					},
				},
			})

			vim.o.autoread = true -- 必须开启


			-- 修复被覆盖的默认增减数字功能
			-- vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
			-- vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })
		end
	}
	vim.opt.completeopt = { "menu", "menuone", "noselect" }
end)

require('render-markdown').setup({
	file_types = { "markdown", "Avante" }
})
-- 3. 快捷键设置 (Keymaps)
local opencode = require("opencode")

-- 基础问答与操作
vim.keymap.set({ "n", "x" }, "<leader>o", function() opencode.ask("@this: ", { submit = true }) end,
	{ desc = "Ask opencode…" })
vim.keymap.set({ "n", "x" }, "<leader>x", function() opencode.select() end, { desc = "Execute opencode action…" })
vim.keymap.set({ "n", "t" }, "<leader>aa", function() opencode.toggle() end, { desc = "Toggle opencode" })

-- Operator 操作符模式
vim.keymap.set({ "n", "x" }, "go", function() return opencode.operator("@this ") end,
	{ desc = "Add range to opencode", expr = true })
vim.keymap.set("n", "goo", function() return opencode.operator("@this ") .. "_" end,
	{ desc = "Add line to opencode", expr = true })

-- 滚动控制
vim.keymap.set("n", "<S-C-u>", function() opencode.command("session.half.page.up") end,
	{ desc = "Scroll opencode up" })
vim.keymap.set("n", "<S-C-d>", function() opencode.command("session.half.page.down") end,
	{ desc = "Scroll opencode down" })

-- require('avante').setup({
-- 	-- system_prompt as function ensures LLM always has latest MCP server state
-- 	-- This is evaluated for every message, even in existing chats
-- 	system_prompt = function()
-- 		local hub = require("mcphub").get_hub_instance()
-- 		return hub and hub:get_active_servers_prompt() or ""
-- 	end,
-- 	-- debug = true,
-- 	-- Using function prevents requiring mcphub before it's loaded
-- 	custom_tools = function()
-- 		return {
-- 			require("mcphub.extensions.avante").mcp_tool(),
-- 		}
-- 	end,
-- 	instructions_file = "avante.md",
-- 	provider = "wq",
-- 	providers = {
-- 		claude = {
-- 			endpoint = "https://api.anthropic.com",
-- 			model = "claude-opus-4-5-20251101",
-- 			timeout = 30000, -- Timeout in milliseconds
-- 			extra_request_body = {
-- 				temperature = 0.75,
-- 				max_tokens = 20480,
-- 			},
-- 		},
-- 		deepseek = {
-- 			__inherited_from = "openai",
-- 			api_key_name = "DEEPSEEK_API_KEY",
-- 			endpoint = "https://api.deepseek.com",
-- 			model = "deepseek-coder",
-- 		},
-- 		agentrouter= {
-- 			__inherited_from = "openai",
-- 		    endpoint = "https://agentrouter.org/v1",
-- 			model = "glm-4.6",
-- 			api_key_name = "AGENTROUTER_API_KEY",
-- 		},
-- 		minimax = {
-- 			__inherited_from = "openai",
-- 			api_key_name = "MINIMAX_API_KEY",
-- 			endpoint = "https://api.minimaxi.com/v1",
-- 			model = "codex-MiniMax-M2.1",
-- 		},
-- 		moss = {
-- 			__inherited_from = "openai",
-- 			api_key_name = "MOSS_API_KEY",
-- 			endpoint = "https://moss.starbucks.net/v1",
-- 			model = "qwen3:235b",
-- 		},
-- 		wq = {
-- 			__inherited_from = "openai",
-- 			api_key_name = "WQ_API_KEY",
-- 			endpoint = "https://wanqing.streamlakeapi.com/api/gateway/v1/endpoints",
-- 			model = "kat-coder-pro-v1",
-- 		},
-- 		gemini = {
-- 			endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
-- 			model = "gemini-3-flash-preview",
-- 			max_tokens = 8192, -- 3.0 支持更长的上下文，可以适当调高
-- 		},
-- 	},
-- 	rag_service = {
-- 		enabled = true,                                            -- 开启 RAG
-- 		runner = "docker",                                         -- RAG 服务的运行器 (可以使用 docker 或 nix)
-- 		llm = {                                                    -- RAG 服务使用的语言模型 (LLM) 配置
-- 			provider = "openai",                                   -- LLM 提供者
-- 			endpoint = "https://api.minimaxi.com/v1",              -- LLM API 端点
-- 			api_key = "MINIMAX_API_KEY",                           -- LLM API 密钥的环境变量名称
-- 			model = "codex-MiniMax-M2.1",                          -- LLM 模型名称
-- 			extra = nil,                                           -- LLM 的额外配置选项
-- 		},
-- 		embed = {                                                  -- RAG 服务使用的嵌入模型配置
-- 			provider = "dashscope",                                -- 嵌入提供者
-- 			endpoint = "https://dashscope.aliyuncs.com/compatible-mode/v1", -- 嵌入 API 端点
-- 			api_key = "QW_API_KEY",                                -- 嵌入 API 密钥的环境变量名称
-- 			model = "text-embedding-v4",
-- 			extra = {                                              -- Extra configuration options for the Embedding model (optional)
-- 				embed_batch_size = 10,
-- 			},
-- 		},
-- 		env = {
-- 			LOG_LEVEL = "debug",
-- 		},
-- 		image = "rag-service:latest",
-- 		host_mount = "/Users/todli/work",
-- 		docker_extra_args = "", -- 传递给 docker 命令的额外参数
--
-- 	}
-- })
local packer = require('packer')
packer.use({
	'kyazdani42/nvim-tree.lua',
	requires = {
		'kyazdani42/nvim-web-devicons', -- optional, for file icons
	},
})

packer.use({
	'SirVer/ultisnips',
	requires = 'honza/vim-snippets',
	config = function() vim.g.UltiSnipsRemoveSelectModeMappings = 0 end,
})

packer.use({
	'quangnguyen30192/cmp-nvim-ultisnips',
	config = function()
		vim.g.UltiSnipsRemoveSelectModeMappings = 0
	end,
})

packer.use('nanotee/sqls.nvim')
packer.use('hrsh7th/cmp-nvim-lsp')
packer.use('hrsh7th/cmp-buffer')
packer.use('hrsh7th/cmp-path')
packer.use('hrsh7th/cmp-cmdline')
packer.use('neovim/nvim-lspconfig')
packer.use('theHamsta/nvim-dap-virtual-text')
packer.use("jbyuki/one-small-step-for-vimkind")
packer.use({
	"rcarriga/nvim-dap-ui",
	tag = 'v2.6.0', -- https://github.com/rcarriga/nvim-dap-ui/issues/371
	requires = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" }
})

packer.use('ravenxrz/DAPInstall.nvim')
packer.use({
	'mfussenegger/nvim-dap',
	tag = '0.10.0'
})
packer.use('windwp/nvim-ts-autotag')


packer.use('navarasu/onedark.nvim')
packer.use('numToStr/Comment.nvim')
packer.use({
	'nvim-lualine/lualine.nvim',
	requires = { 'kyazdani42/nvim-web-devicons', opt = true }
})
packer.use('kevinhwang91/nvim-bqf')
packer.use('voldikss/vim-floaterm')
packer.use("windwp/nvim-autopairs")
packer.use('voldikss/vim-translator')
packer.use({
	'crusj/structrue-go.nvim',
	branch = "main"
})
-- packer.use('preservim/tagbar')

local util = require("base.util")

-- load plugin
require("small.group")
require("lsp.dap")
-- require("lsp.avante")
require("tree.tree")
require("base.keymap")
require("lsp.lsp")
require("lsp.ultest")
require("docker.docker")

-- nvim-treesitter
require 'nvim-treesitter.configs'.setup {
	-- A list of parser names, or "all"
	ensure_installed = { "go", "c", "c", "lua", "vim", "vimdoc", "query" },

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
			fuzzy = true,          -- false will only do exact matching
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

-- sniprun
util.keymap("", "<leader>rr", "<cmd>SnipRun<CR>")
require 'sniprun'.setup({
	selected_interpreters = {}, --# use those instead of the default for the current filetype
	repl_enable = {},        --# enable REPL-like behavior for the given interpreters
	repl_disable = {},       --# disable REPL-like behavior for the given interpreters
	interpreter_options = {  --# interpreter-specific options, see docs / :SnipInfo <name>

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
		SniprunVirtualTextOk  = { bg = "#66eeff", fg = "#000000", ctermbg = "Cyan", ctermfg = "Black" },
		SniprunFloatingWinOk  = { fg = "#66eeff", ctermfg = "Cyan" },
		SniprunVirtualTextErr = { bg = "#881515", fg = "#000000", ctermbg = "DarkRed", ctermfg = "Black" },
		SniprunFloatingWinErr = { fg = "#881515", ctermfg = "DarkRed" },
	},
	--# miscellaneous compatibility/adjustement settings
	inline_messages = 0, --# inline_message (0/1) is a one-line way to display messages
	--# to workaround sniprun not being able to display anything

	borders = 'single',   --# display borders around floating windows
	--# possible values are 'none', 'single', 'double', or 'shadow'
	live_mode_toggle = 'off' --# live mode toggle, see Usage - Running for more info
})

-- ultisnips
util.cmd('let g:UltiSnipsExpandTrigger="<CR>"')
util.cmd('let g:UltiSnipsJumpForwardTrigger="<c-b>"')
util.cmd('let g:UltiSnipsJumpBackwardTrigger="<c-z>"')

--
require("hierarchy-tree-go").setup()

return
