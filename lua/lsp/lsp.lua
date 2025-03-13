local util = require("base.util")
local gohelp = require("base.go_help")
local log = require('base.log')

-- vim-go todo only use gopls
-- packer.use('fatih/vim-go')
--
function GoAddTagsPlugin()
	local linenr = vim.api.nvim_win_get_cursor(0)[1]
	local source = vim.api.nvim_buf_get_lines(0, linenr - 1, linenr, false)[1]
	local flags = vim.fn.inputlist({
		'Select the debugging mode for tags:',
		'(1):json.',
		'(2):gorm.',
		'(3):schema.',
		'(4):yaml.',
		'(5):custom.',
	})

	local tag = ""
	if (flags == 2) then
		tag = "gorm"
	elseif (flags == 3) then
		tag = "schema"
	elseif (flags == 4) then
		tag = "yaml"
	elseif (flags == 5) then
		tag = vim.fn.input("args:")
	else
		tag = "json"
	end

	source = string.gsub(string.gsub(source, "\"", "\\\""), "`", "\\`")
	vim.api.nvim_buf_set_lines(0, linenr - 1, linenr, false, { gohelp.AddTags(source, tag) })
end

function GoAddTagPlugin()
	local linenr = vim.api.nvim_win_get_cursor(0)[1]
	local source = vim.api.nvim_buf_get_lines(0, linenr - 1, linenr, false)[1]
	print(source, vim.api.nvim_buf_get_lines(0, linenr - 1, linenr, false)[2])
end

-- util.keymap('', "<F1>", ":GoDocBrowser<CR>")
-- util.keymap('n', "<leader>fill", ":GoFillStruct<CR>")
util.keymap('n', "<leader>tg", GoAddTagsPlugin)
util.keymap('v', "<leader>tc", GoAddTagPlugin)

-- util.keymap('v', "<leader>tg", ": luado return require'lsp.lsp'.GoAddTagsPlugin(line,linenr)<CR>")

vim.g.go_def_mapping_enabled = 0
--

--lsp
--lua print(vim.lsp.get_log_path())
-- vim.lsp.set_log_level("debug")
require("cmp_nvim_ultisnips").setup {}

local cmp = require('cmp')
local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")

util.setVimCommand({
	'let g:UltiSnipsSnippetDirectories=[$HOME."/snippets"]'
})
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

--
local on_attach = function(_, bufnr)
	-- local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
	local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
	buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
end
--
-- close quickfix
util.keymap("", "<leader>a", ":cclose<CR>")
--
local lspconfig = require('lspconfig')
-- golang
lspconfig.gopls.setup {
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
			staticcheck = true,
			gofumpt = true,
		},
	},
	init_options = {
		usePlaceholders = true,
	}
}

function CustomGoFlags()
	local flags = vim.fn.input("GOFLAGS:")
	util.cmd("let $GOFLAGS=\"-tags=" .. flags .. "\"")
	util.cmd("LspRestart")
end

util.keymap("n", "<leader>bm", ":let $GOFLAGS=\"-tags=darwin\" <CR> :let $GOOS=\"darwin\" <CR> :LspRestart<CR>")
util.keymap("n", "<leader>bw", ":let $GOFLAGS=\"-tags=windows\" <CR> :let $GOOS=\"windows\"<CR> :LspRestart<CR>")
util.keymap("n", "<leader>bl", ":let $GOFLAGS=\"-tags=linux\" <CR> :let $GOOS=\"linux\" <CR> :LspRestart<CR>")
util.keymap("n", "<leader>bb", function()
	require 'lsp.lsp'
	CustomGoFlags()
end)
util.keymap("n", "<leader>sw", function() require 'base.util'.sudoWrite() end)

--
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.go" },
	callback = function()
		local params = vim.lsp.util.make_range_params(nil, vim.lsp.util._get_offset_encoding())
		params.context = { only = { "source.organizeImports" } }

		local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
		for _, res in pairs(result or {}) do
			for _, r in pairs(res.result or {}) do
				if r.edit then
					vim.lsp.util.apply_workspace_edit(r.edit, vim.lsp.util._get_offset_encoding())
				else
					vim.lsp.buf.execute_command(r.command)
				end
			end
		end
	end,
})


-- lua
lspconfig.lua_ls.setup {
	on_init = function(client)
		local path = client.workspace_folders[1].name
		if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
			client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
				Lua = {
					runtime = {
						-- Tell the language server which version of Lua you're using
						-- (most likely LuaJIT in the case of Neovim)
						version = 'LuaJIT'
					},
					-- Make the server aware of Neovim runtime files
					workspace = {
						checkThirdParty = false,
						library = {
							vim.env.VIMRUNTIME
							-- "${3rd}/luv/library"
							-- "${3rd}/busted/library",
						}
						-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
						-- library = vim.api.nvim_get_runtime_file("", true)
					}
				}
			})

			client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
		end
		return true
	end
}

require('nvim-ts-autotag').setup({
	opts = {
		-- Defaults
		enable_close = true,    -- Auto close tags
		enable_rename = true,   -- Auto rename pairs of tags
		enable_close_on_slash = false -- Auto close on trailing </
	},
	-- Also override individual filetype configs, these take priority.
	-- Empty by default, useful if one of the "opts" global settings
	-- doesn't work well in a specific filetype
	per_filetype = {
		["html"] = {
			enable_close = false
		}
	}
})

-- lspconfig.ts_ls.setup {
-- 	init_options = {
-- 		plugins = {
-- 			{
-- 				name = '@vue/typescript-plugin',
-- 				location = '/path/to/@vue/language-server',
-- 				languages = { 'vue' },
-- 			},
-- 		},
-- 	},
-- }

lspconfig.volar.setup {
	filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
	init_options = {
		vue = {
			hybridMode = false,
		},
	},
}
--
-- jsonnet
lspconfig.jsonnet_ls.setup {
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
--
-- josn
--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
--
lspconfig.jsonls.setup {
	capabilities = capabilities,
}
--
-- clang
lspconfig.clangd.setup {}
--
-- yaml
lspconfig.yamlls.setup {
	settings = {
		yaml = {
			schemas = {
				["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
			},
		},
	}
}

lspconfig.sqls.setup {
	on_attach = function(client, bufnr)
		require('sqls').on_attach(client, bufnr) -- require sqls.nvim
	end,
	settings = {
		sqls = {
			connections = {
				{
					driver = 'mysql',
					dataSourceName = 'root:123456@tcp(127.0.0.1:3306)/opamp',
				}
			},
		},
	},
}
-- java
local config = {
    cmd = {'jdtls'},
    root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]),
}
require('jdtls').start_or_attach(config)
-- require 'lspconfig'.java_language_server.setup {}
--
-- lsp-config
--
local bufopts = { noremap = true, silent = true, buffer = bufnr }
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>d', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
vim.keymap.set('n', '<C-]>', vim.lsp.buf.definition, bufopts)
-- vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
vim.keymap.set('n', '<C-;>', vim.lsp.buf.signature_help, bufopts)
-- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
-- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
--[[ vim.keymap.set('n', '<space>wl', function() ]]
--[[ print(vim.inspect(vim.lsp.buf.list_workspace_folders())) ]]
--[[ end, bufopts) ]]
vim.keymap.set('', '<C-C>', vim.lsp.buf.completion, bufopts)
vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
vim.keymap.set('', '<leader>rn', vim.lsp.buf.rename, bufopts)
vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
vim.keymap.set('', '<C-R>', function()
	vim.lsp.buf.format { async = true }
end, bufopts)
vim.keymap.set('', "gh", vim.lsp.buf.code_action, bufopts)
--
-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
	sources = cmp.config.sources({
		{ name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
	}, {
		{ name = 'buffer' },
	})
})
-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
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
	}),
	matching = { disallow_symbol_nonprefix_matching = false }
})
