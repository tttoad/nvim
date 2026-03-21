-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local util = require("config.util")

util.setVimKeyMap({
  "imap <c-k> <up>",
  "imap <c-h> <left>",
  "imap <c-j> <down>",
  "imap <c-l> <right>",
  "imap <c-a> <esc>I",
  "nmap <c-a> ^",
  "vnoremap <c-a> ^",
  "inoremap <c-e> <esc>A",
  "nnoremap <c-e> $",
  "vnoremap <c-e> $",
  "nnoremap m 10j",
  "nnoremap , 10k",
  "vnoremap m 10j",
  "vnoremap , 10k",

  -- "",
  "imap <c-g> <esc>GG",
  "imap <c-o> <esc>o",
  "imap <c-u> <esc>u",
  "imap <c-d> <esc>ddi",
  "nmap <c-k> <up>",
  "nmap <c-h> <left>",
  "nmap <c-j> <down>",
  "nmap <c-l> <right>",
  "inoremap <c-t> <esc>yyi",
  "nnoremap <c-t> <c-o>",
  "imap <c-p> <esc>pi",
  "nnoremap <c-G> GG",
  "imap <c-G> <esc>GG",
  "imap <c-s> <esc>:w<cr>",
  "nmap <c-s> :w<cr>",
  "nmap L $",
  "nmap H ^",
  -- 'noremap <c-w> <c-w>w',
  'vmap <leader>y "+y',
  'vnoremap <c-d> "+d',
  'nmap <leader>v "+p',
  "noremap <c-x> <c-r>",
  "map <C-n> :cnext<CR>",
  "map <C-m> :cprevious<CR>",
})

util.setVimCommand({
  "set number",
  "set ignorecase",
  "set encoding=UTF-8",
  -- 'set number',
  --set lines=60
  --set columns=200
  "set mouse=a",
  -- 'syntax on',
  "set cursorline",
  "set laststatus=2",
  --set autoindent',
  "set tabstop=4",
  "set smarttab",
  "set shiftwidth=4",
  "set softtabstop=4",
  "set backspace=eol,start,indent",

  "set showcmd",
  "set whichwrap+=<,>,h,l",
  "set scrolloff=3",
  "set history=1000",
  "set nobackup",
  "set nocompatible",
  -- set verbosefile=./vim.log',
  "set cmdheight=2",
  -- 'set completeopt-=preview',
  "set completeopt=menu,menuone,noselect",
  "set signcolumn=yes",
  "set autowriteall",
  "set autoread",
  ":autocmd InsertEnter * set cul",
  ":autocmd InsertLeave * set nocul",

  "set splitbelow",
})

util.keymap("v", "<localleader>tt", ": luado return require'config.util'.FormatVar(line,linenr)<CR>")
util.keymap("n", "<localleader>tt", "V: luado return require'config.util'.FormatVar(line,linenr)<CR>")
util.keymap("n", "<localleader>t{", "vi{: luado return require'config.util'.FormatVar(line,linenr)<CR>")
