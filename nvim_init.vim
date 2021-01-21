" Vim Plug and Plugins {{{
call plug#begin('~/.local/share/nvim/site/autoload/')
" colorschemes
Plug 'sjl/badwolf'
Plug 'gruvbox-community/gruvbox'

" statusline
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Plugins
Plug 'tomtom/tcomment_vim'
Plug 'lambdalisue/fern.vim'
Plug 'tommcdo/vim-lion'

Plug 'machakann/vim-sandwich'
Plug 'machakann/vim-highlightedyank' "To be removed in neovim 0.5

Plug 'rust-lang/rust.vim'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'jupyter-vim/jupyter-vim'
Plug 'hkupty/iron.nvim'
Plug 'goerz/jupytext.vim'

Plug 'junegunn/fzf.vim'
Plug '~/.fzf'

call plug#end()
"}}}
" Basic options {{{

" Colors
syntax enable           " enable syntax processing
let g:gruvbox_italic=1
colorscheme gruvbox
set encoding=utf8
set termguicolors

" Spaces & Tabs
set tabstop=4           " 4 space tab
set expandtab           " use spaces for tabs
set softtabstop=4       " 4 space tab
set shiftwidth=4
set modelines=1
filetype indent on
filetype plugin on
set autoindent

" UI Layout
set number              " show line numbers
set showcmd             " show command in bottom bar
set cursorline          " highlight current line
set wildmenu
set lazyredraw          " disable redrawing when executing marcro
set showmatch           " higlight matching parenthesis
set fillchars=diff:⣿,vert:\|
set synmaxcol=800       " Don't try to highlight lines longer than 800 characters.
set scrolloff=7         " Set 7 lines to the cursor - when moving vertically using j/k
set clipboard+=unnamedplus      " This will make the system clipboard and vim's clipboard equal

" Searching
set ignorecase          " ignore case when searching
set incsearch           " search as characters are entered
set hlsearch            " highlight all matches
set inccommand=split    " incremental visual feedback when doing the substitute command

" Folding
set foldmethod=indent   " fold based on indent level
set foldnestmax=10      " max 10 depth
set foldenable          " don't fold files by default on open
set foldlevelstart=10   " start with fold level of 1

" Splitting
set splitbelow
set splitright

" Backup
set backup
set writebackup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set backupskip=/tmp/*,/private/tmp/*
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" Persistent Undo
set undofile                " Save undos after file closes
set undodir=$HOME/.vim-undo " where to save undo histories
set undolevels=1000         " How many undos
set undoreload=10000        " number of lines to save for undo
" }}}
" neovim {{{
let g:python3_host_prog = '/usr/bin/python3'
" }}}
" Custom Functions {{{
function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction
" }}}
" autocmd {{{
" Delete Trailing Spaces automatically
" autocmd BufWritePre * %s/\s\+$//e
" https://stackoverflow.com/questions/6496778/vim-run-autocmd-on-all-filetypes-except
fun! StripTrailingWhitespace()
    " Don't strip on these filetypes
    if &ft =~ 'markdown'
        return
    endif
    %s/\s\+$//e
endfun

autocmd BufWritePre * call StripTrailingWhitespace()

" Reload file to match with foreign changes
set autoread
au FocusGained,BufEnter * :checktime
" }}}
" Remappings {{{
nnoremap j gj
nnoremap k gk
imap jk <Esc>
imap Jk <Esc>
imap jK <Esc>
imap JK <Esc>

nnoremap Q <nop>
nnoremap Y y$

" keep selection while indenting in visual-mode
vnoremap < <gv
vnoremap > >gv

" split navigation
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" Select entire buffer
nnoremap vaa ggvGg_
nnoremap Vaa ggVG

" Keep search matches in the middle of the window.
nnoremap n nzzzv
nnoremap N Nzzzv

" easy folding
nnoremap , za

xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

nnoremap L g_
nnoremap H 0
onoremap L g_
onoremap H 0

" also clear search with <Esc>
nnoremap <esc> :noh<return><esc>
" }}}
" Leader mappings {{{
let mapleader="\<Space>"

nnoremap <leader>ev :e $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

nnoremap <leader>, :noh<CR>

" exectuing
vnoremap <leader>n :normal<space>

" neovim terminal mode helpers
nnoremap <leader>t :vsplit term://bash<cr>

nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bk :bdelete<CR>

" }}}
" Plugin Settings {{{
" highlightedyank
let g:highlightedyank_highlight_duration = 300

" airline
let g:airline_theme = 'zenburn'

" fzf
autocmd! FileType fzf tnoremap <buffer> <esc> <c-c>

" vim-sandwich's vim-surround keybindings
runtime macros/sandwich/keymap/surround.vim

" jupyter-vim
let g:jupyter_mapkeys = 0
" Run current file
nnoremap <leader>cf :JupyterRunFile<CR>
" Change to directory of current file
nnoremap <leader>cd :JupyterCd %:p:h<CR>
" Send a selection of lines
nnoremap <leader>cc :JupyterSendCell<CR>
nnoremap <leader>cr :JupyterSendRange<CR>
nmap     <leader>cr <Plug>JupyterRunTextObj
vmap     <leader>cr <Plug>JupyterRunVisual

" Fern {{{
noremap <silent> <C-n> :Fern . -drawer -reveal=% -toggle -width=35<CR><C-w>=

let g:fern#disable_default_mappings   = 1
let g:fern#disable_drawer_auto_quit   = 1
let g:fern#disable_viewer_hide_cursor = 1

function! FernInit() abort
  nmap <buffer><expr>
        \ <Plug>(fern-my-open-expand-collapse)
        \ fern#smart#leaf(
        \   "\<Plug>(fern-action-open:select)",
        \   "\<Plug>(fern-action-expand:in)",
        \   "\<Plug>(fern-action-collapse)",
        \ )
  nmap <buffer> <CR> <Plug>(fern-my-open-expand-collapse)
  nmap <buffer> m <Plug>(fern-action-mark:toggle)j
  nmap <buffer> N <Plug>(fern-action-new-file)
  nmap <buffer> K <Plug>(fern-action-new-dir)
  nmap <buffer> D <Plug>(fern-action-remove)
  nmap <buffer> V <Plug>(fern-action-move)
  nmap <buffer> R <Plug>(fern-action-rename)
  nmap <buffer> s <Plug>(fern-action-open:split)
  nmap <buffer> v <Plug>(fern-action-open:vsplit)
  nmap <buffer> r <Plug>(fern-action-reload)
  nmap <buffer> <nowait> d <Plug>(fern-action-hidden:toggle)
  nmap <buffer> <nowait> < <Plug>(fern-action-leave)
  nmap <buffer> <nowait> > <Plug>(fern-action-enter)
endfunction

augroup FernEvents
  autocmd!
  autocmd FileType fern call FernInit()
augroup END
" }}}
" }}}

" vim:foldmethod=marker:foldlevel=0
