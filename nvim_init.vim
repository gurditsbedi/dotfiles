" Vim Plug and Plugins {{{
call plug#begin('~/.local/share/nvim/site/autoload/')
" colorschemes
Plug 'sjl/badwolf'
Plug 'joshdick/onedark.vim'
Plug 'iCyMind/NeoSolarized'

" statusline
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Plugins
Plug 'tomtom/tcomment_vim'
Plug 'preservim/nerdtree'

Plug 'machakann/vim-sandwich'

Plug 'rust-lang/rust.vim'

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

Plug 'jupyter-vim/jupyter-vim'

Plug 'junegunn/fzf.vim'
Plug '~/.fzf'

call plug#end()
"}}}
" Basic options {{{

" Colors
syntax enable           " enable syntax processing
colorscheme badwolf
let g:badwolf_darkgutter = 1
let g:badwolf_tabline = 3
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

" Searching
set ignorecase          " ignore case when searching
set incsearch           " search as characters are entered
set hlsearch            " highlight all matches

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
autocmd BufWritePre * %s/\s\+$//e
" }}}
" Remappings {{{
nnoremap j gj
nnoremap k gk
imap jk <Esc>

nnoremap Q <nop>
nnoremap Y y$

" keep selection while indenting in visual-mode
vnoremap < <gv
vnoremap > >gv

" buffer navigation
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

" }}}
" Leader mappings {{{
let mapleader="\<Space>"

nnoremap <leader>ev :vsp $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

nnoremap <leader>, :noh<CR>

" Wrap
nnoremap <leader>W :set wrap!<cr>

" Copying/pasting text to the system clipboard.
noremap  <leader>p "+p
vnoremap <leader>y "+y
nnoremap <leader>y VV"+y
nnoremap <leader>Y "+y

" exectuing
vnoremap <leader>n :normal<space>

" neovim terminal mode helpers
nnoremap <leader>t :vsplit term://bash<cr>
" }}}
" Plugin Settings {{{
" nerdtree
map <C-n> :NERDTreeToggle<CR>

" airline
set laststatus=2
let g:airline_theme = 'zenburn'

" fzf mappings
nnoremap <silent> <Leader>ag       :Ag <C-R><C-W><CR>
nnoremap <silent> <Leader>AG       :Ag <C-R><C-A><CR>
xnoremap <silent> <Leader>ag       y:Ag <C-R>"<CR>

" deoplete clang
let g:deoplete#enable_at_startup = 1
autocmd CompleteDone * pclose!

" LanguageClient-neovim
let g:LanguageClient_serverCommands = {
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    \ 'python': ['pyls'],
    \ 'c': ['clangd-8'],
    \ 'cpp': ['clangd-8'],
    \ }
nnoremap <Leader>l :call LanguageClient_contextMenu()<CR>

" vim-sandwich's vim-surround keybindings
runtime macros/sandwich/keymap/surround.vim
" }}}

" vim:foldmethod=marker:foldlevel=0
