if &compatible
  set nocompatible
endif

let mapleader = "\<Space>"

" deinの実行パス
set runtimepath+=$HOME/.cache/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')
  call dein#load_toml('~/.config/nvim/dein.toml')
  call dein#load_toml('~/.config/nvim/dein_lazy.toml', {'lazy': 1})
  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
syntax enable

if dein#check_install()
  call dein#install()
endif

autocmd VimEnter * call dein#call_hook('post_source')

" setting
set history=200
set ruler
set number
set relativenumber
set nowrap
set showcmd
set wildmenu
set display=truncate
set incsearch
set autoread
set autoindent
set smartindent
set tabstop=4
set softtabstop=0
set shiftwidth=2
set expandtab
set smarttab
set nobackup
set noswapfile
set noundofile

" clipboard
set clipboard^=unnamedplus
let g:clpboard = {
      \     'name': 'wslClipboard',
      \     'copy': {
      \         '+': 'win32yank.exe -i',
      \         '*': 'win32yank.exe -i',
      \     },
      \     'paste': {
      \         '+': 'win32yank.exe -o',
      \         '*': 'win32yank.exe -o',
      \     },
      \     'cache_enabled': 1
      \ }

" map
inoremap <C-j> <ESC>
vnoremap <C-j> <ESC>
nnoremap <silent> <Leader>wk <C-w>k
nnoremap <silent> <Leader>wl <C-w>l
nnoremap <silent> <Leader>wj <C-w>j
nnoremap <silent> <Leader>wh <C-w>h

nnoremap <silent> <Leader>wv <C-w>v
nnoremap <silent> <Leader>ws <C-w>s

" function / command

" 設定ファイルを反映するやつ
" 再定義しちゃうので存在チェックつき
if !exists("*ConfigSource")
  function! ConfigSource()
    so ~/.config/nvim/init.vim
    echo '設定が反映されたンゴ'
  endfunction
  nnoremap <silent> <leader>cs :call ConfigSource()<CR>
endif

" 設定にいくやつ
if !exists("*ConfigEnter")
  function! ConfigEnter()
    cd ~/.config/nvim
    $tabnew init.vim
  endfunction
  nnoremap <silent> <leader>ce :call ConfigEnter()<CR>
endif

" 設定を出るやつ
if !exists("*ConfigLeave")
  function! ConfigLeave()
    $tabclose
    call ConfigSource()
    cd -
  endfunction
  nnoremap <silent> <leader>cl :call ConfigLeave()<CR>
endif
