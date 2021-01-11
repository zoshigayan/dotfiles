if &compatible
  set nocompatible
endif

" vim-plug なかったら落としてくる
if empty(glob('$HOME/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" 足りないプラグインがあれば :PlugInstall を実行
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin('$HOME/.local/share/nvim/plugged')
Plug 'NLKNguyen/papercolor-theme'
Plug 'lambdalisue/fern.vim'
Plug 'tpope/vim-surround'
Plug 'dense-analysis/ale'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'easymotion/vim-easymotion'
Plug 'cespare/vim-toml', { 'for': 'toml' }
Plug 'peitalin/vim-jsx-typescript', { 'for': ['typescript', 'typescriptreact'] }
Plug 'HerringtonDarkholme/yats.vim', { 'for': ['typescript', 'typescriptreact'] }
Plug 'mhartington/nvim-typescript', { 'for': ['typescript', 'typescriptreact'] }
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
call plug#end()

" setting
filetype plugin indent on
syntax enable
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
set updatetime=100
let mapleader = "\<Space>"

set background=dark
colorscheme PaperColor
let g:airline_theme = 'papercolor'

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
inoremap <silent> <C-j> <ESC>
vnoremap <silent> <C-j> <ESC>

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

" vimgrepでQuickfixひらくやつ
autocmd QuickFixCmdPost *grep* cwindow

" :grep で ripgrep つかうやつ
if executable("rg")
    let &grepprg = 'rg --vimgrep --hidden > /dev/null'
    set grepformat=%f:%l:%c:%m
endif

" ale
let g:ale_fix_on_save = 1
let g:ale_sign_column_always = 1
let g:ale_linters = {
\  'typescript': ['eslint', 'tsserver', 'typecheck'],
\  'typescriptreact': ['eslint', 'tsserver', 'typecheck'],
\  'javascript': ['eslint', 'tsserver', 'typecheck'],
\  'python': ['pycodestyle'],
\  'ruby': ['rubocop'],
\ }
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'typescript': ['eslint'],
\   'typescriptreact': ['eslint'],
\   'javascript': ['eslint'],
\   'python': ['autopep8'],
\   'go': ['gofmt'],
\   'ruby': [],
\   }

nnoremap <silent> <Leader>ad :ALEDetail<CR>
nnoremap <silent> <Leader>ai :ALEInfo<CR>

" fern
nnoremap <silent> <Leader>e :Fern . -drawer -width=40 -toggle<CR>
