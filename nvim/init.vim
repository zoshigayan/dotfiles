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
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'easymotion/vim-easymotion'
Plug 'cespare/vim-toml', { 'for': 'toml' }
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'MaxMEllon/vim-jsx-pretty', { 'for': ['typescript', 'typescriptreact'] }
Plug 'HerringtonDarkholme/yats.vim', { 'for': ['typescript', 'typescriptreact'] }
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'othree/html5.vim'
Plug 'evanleck/vim-svelte', {'branch': 'main'}
Plug 'hashivim/vim-terraform'
Plug 'github/copilot.vim'
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
colorscheme darkblue
let g:airline_theme = 'dark'
let g:airline_powerline_fonts = 0

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

" fugitive
nnoremap <silent> <Leader>gg :Git<CR>
nnoremap <silent> <Leader>glo :GBrowse!<CR>
vnoremap <silent> <Leader>glo :GBrowse!<CR>
nnoremap <silent> <Leader>glu :GBrowse! @upstream<CR>
vnoremap <silent> <Leader>glu :GBrowse! @upstream<CR>

" fern
nnoremap <silent> <Leader>e :Fern . -drawer -width=40 -toggle<CR>

function! FZGrep(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call FZGrep(<q-args>, <bang>0)

nnoremap <silent> <Leader>,p :GFiles<CR>
nnoremap <silent> <Leader>,P :Files<CR>
nnoremap <silent> <Leader>,s :RG<CR>
nnoremap <silent> <Leader>,c :Commits<CR>

" coc
" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

function! s:show_documentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" svelte
let g:svelte_indent_script = 0
let g:svelte_indent_style = 0
let g:svelte_preprocessors = ['typescript']
