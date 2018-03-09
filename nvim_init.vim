" Vim Plug and Plugins {{{
call plug#begin('~/.local/share/nvim/site/autoload/')
" colorschemes
Plug 'sjl/badwolf'
Plug 'joshdick/onedark.vim'
Plug 'iCyMind/NeoSolarized'

" Plugins
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'itchyny/lightline.vim'

Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'

Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-abolish'

Plug 'tomtom/tlib_vim'
Plug 'garbas/vim-snipmate'
Plug 'honza/vim-snippets'
Plug 'MarcWeber/vim-addon-mw-utils'

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-jedi'
Plug 'Rip-Rip/clang_complete', { 'for': ['c', 'cpp'] }
Plug 'fszymanski/deoplete-emoji'
"Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }

Plug 'Shougo/denite.nvim'
"Plug 'donRaphaco/neotex', { 'for': 'tex' }
Plug 'neomake/neomake'
Plug 'purescript-contrib/purescript-vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'



Plug 'mattn/emmet-vim'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }

" Language specific
Plug 'rust-lang/rust.vim'
Plug 'HerringtonDarkholme/yats.vim'
"Plug 'mhartington/nvim-typescript'
call plug#end()
"}}}
" Colors {{{
syntax enable           " enable syntax processing
colorscheme onedark
let g:badwolf_darkgutter = 1
let g:badwolf_tabline = 3
set encoding=utf8
set termguicolors
" }}}
" Spaces & Tabs {{{
set tabstop=4           " 4 space tab
set expandtab           " use spaces for tabs
set softtabstop=4       " 4 space tab
set shiftwidth=4
set modelines=1
filetype indent on
filetype plugin on
set autoindent
" }}}
" UI Layout {{{
set number              " show line numbers
set showcmd             " show command in bottom bar
set cursorline        " highlight current line
set wildmenu
set lazyredraw
set showmatch           " higlight matching parenthesis
set fillchars+=vert:┃
set scrolloff=7         " Set 7 lines to the cursor - when moving vertically using j/k
" }}}
" Searching {{{
set ignorecase          " ignore case when searching
set incsearch           " search as characters are entered
set hlsearch            " highlight all matches
" }}}
" Folding {{{
"=== folding ===
set foldmethod=indent   " fold based on indent level
set foldnestmax=10      " max 10 depth
set foldenable          " don't fold files by default on open
nnoremap <space> za
set foldlevelstart=10   " start with fold level of 1
" }}}
" Remappings {{{
nnoremap j gj
nnoremap k gk
imap jk <Esc>
nnoremap Q <nop>
vnoremap < <gv
vnoremap > >gv
" }}}
" Backups {{{
set backup
set writebackup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set backupskip=/tmp/*,/private/tmp/*
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
" }}}
" neovim {{{
let g:python3_host_prog = '/usr/bin/python3'
" }}}
" airline {{{
set laststatus=2
"let g:airline_theme = 'zenburn'
"let g:airline_left_sep = ''
"let g:airline_left_sep = ''
"let g:airline_right_sep = ''
"let g:airline_right_sep = ''
" }}}
" nerdtree {{{
map <C-n> :NERDTreeToggle<CR>
" }}}
" deoplete {{{
let g:deoplete#enable_at_startup = 1
let g:clang_library_path='/usr/lib/llvm-3.8/lib/libclang-3.8.so.1'
autocmd CompleteDone * pclose!
" }}}
" Custom Functions {{{
function! ToggleNumber()
    if(&relativenumber == 1)
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunc
" }}}
" autocmd {{{
" Delete Trailing Spaces automatically
autocmd BufWritePre * %s/\s\+$//e
" Neomake execute every buffer save
autocmd! BufWritePost * Neomake
" }}}
" Leader Shortcuts {{{
let mapleader=","
nnoremap <leader>ev :vsp $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
nnoremap <leader>l :call ToggleNumber()<CR>
nnoremap <leader><space> :noh<CR>
nnoremap <leader>1 :set number!<CR>
vnoremap <leader>y "+y
" }}}
" neomake{{{
let g:neomake_python_enabled_makers = ['flake8', 'pep8']
" E501 is line length of 80 characters
let g:neomake_python_flake8_maker = { 'args': ['--ignore=E501'], }
let g:neomake_python_pep8_maker = { 'args': ['--ignore=E501'], }
" }}}
" fzf mappings {{{
nnoremap <silent> <expr> <Leader><Leader> (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":Files\<cr>"
nnoremap <silent> <Leader>C        :Colors<CR>
nnoremap <silent> <Leader><Enter>  :Buffers<CR>
nnoremap <silent> <Leader>ag       :Ag <C-R><C-W><CR>
nnoremap <silent> <Leader>AG       :Ag <C-R><C-A><CR>
xnoremap <silent> <Leader>ag       y:Ag <C-R>"<CR>
nnoremap <silent> <Leader>`        :Marks<CR>

" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)
" }}}
"


let g:neomake_javascript_enabled_makers = ['eslint']
let g:jsx_ext_required = 0
autocmd FileType javascript set formatprg=prettier\ --stdin
autocmd FileType javascript set shiftwidth=2





" vim:foldmethod=marker:foldlevel=0
