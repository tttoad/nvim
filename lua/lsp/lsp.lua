local packer = require("packer")
local util = require("base.util")
-- vim-go
packer.use 'fatih/vim-go'
util.keymap('', "<F1>", ":GoDocBrowser<CR>")
util.keymap('n', "<leader><space>i", ":GoImpl ")
util.keymap('n', "<leader>fill", ":GoFillStruct<CR>")
util.keymap('n', "<leader>f", ":GoReferrers<CR>")
util.keymap('n', "<leader>c", ":GoCallees<CR>")
util.keymap('n', "<leader>tg", ":GoAddTags<CR>")


-- lsp
packer.use 'hrsh7th/cmp-nvim-lsp'
packer.use 'hrsh7th/cmp-buffer'
packer.use 'hrsh7th/cmp-path'
packer.use 'hrsh7th/cmp-cmdline'
packer.use 'hrsh7th/nvim-cmp'

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

-- nvim-cmp
-- local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()) --nvim-cmp
-- capabilities.textDocument.completion.completionItem.snippetSupport = true

local on_attach = function(_, bufnr)
	-- local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

	local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

	buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
end

-- close quickfix
util.keymap("", "<leader>a", ":cclose<CR>")

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

util.cmd("autocmd BufWritePre *.go lua Go_org_imports()")
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