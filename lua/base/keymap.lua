local util = require("base.util")

util.setVimKeyMap({
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

util.setVimCommand({
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

util.keymap("n", "<leader>bm", ":let $GOFLAGS=\"-tags=darwin\" <CR> :let $GOOS=\"darwin\" <CR> :LspRestart<CR>")
util.keymap("n", "<leader>bw", ":let $GOFLAGS=\"-tags=windows\" <CR> :let $GOOS=\"windows\"<CR> :LspRestart<CR>")
util.keymap("n", "<leader>bl", ":let $GOFLAGS=\"-tags=linux\" <CR> :let $GOOS=\"linux\" <CR> :LspRestart<CR>")
