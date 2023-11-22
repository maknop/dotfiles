"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   Plugins - General 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Setting up Vundle
set nocompatible
filetype off
call plug#begin()

" Color schemes
Plug 'morhetz/gruvbox'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'navarasu/onedark.nvim'

" Markdown preview
Plug 'JamshedVesuna/vim-markdown-preview'

" Vim Personal Wiki
Plug 'vimwiki/vimwiki'

" Python
Plug 'hynek/vim-python-pep8-indent'   " Proper PEP8 indents

" HTML
Plug 'alvan/vim-closetag'             " Auto-complete tags

" CSS
Plug 'hail2u/vim-css3-syntax'         " Better highlighting for nvim

" JavaScript
Plug 'beautify-web/js-beautify'       " Beautifier
Plug 'pangloss/vim-javascript'        " Better syntax highlighting
Plug 'mxw/vim-jsx'                    " JSX syntax highlighting (ReactJS)

" Golang
Plug 'fatih/vim-go'                   " Go development plugin for nvim

" nvim goodies
Plug 'nvim-lua/completion-nvim'       " Autocomplete for nvim
Plug 'scrooloose/nerdtree'            " File browser for nvim
Plug 'scrooloose/nerdcommenter'       " Auto comment out lines
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'               " Fuzzy finder
Plug 'kien/ctrlp.vim'                 " Browse files
Plug 'jiangmiao/auto-pairs'           " Insert or delete brackets, parents, quotes in pair
Plug 'vim-airline/vim-airline'        "Vim airline

" Required for Vundle
call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set encoding=utf-8
set scrolloff=5             
set showmode                    " Displays current mode
set ruler                       " Shows line and column of position
set number                  
set backspace=indent,eol,start
set noswapfile                  " Disables swap files

set mouse=a


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   Indentation, column highlighting, Search/Replace
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set tabstop=4                   " Indent to four spaces
set expandtab                   " Spaces, not tabs
set autoindent
set smartindent
set wrap                        " Lines wrap
set cursorcolumn                " Column cursorline

set ignorecase                  " Ignores case when searching


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   Key Bindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Rebind line navigation keys
nnoremap j gj
nnoremap k gk
nnoremap H ^
nnoremap L $

" Rebind back a word keys
nnoremap w b

"Change windows with <C-movement>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
noremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Copying to system clipboard
vnoremap <C-c> "+y

" Toggle paste mode
nnoremap <C-p> :set paste!<cr>

" Entering command mode with ; instead of :
nnorema ; :

" Exiting insert mode
inoremap jk <ESC>
inoremap JK <ESC>

" Open NERDTree with ctrl+n
map <C-n> :NERDTreeToggle<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   General/Plugin Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax enable on
filetype plugin indent on
filetype plugin on

set tabstop=4
set shiftwidth=4

" Nerdtree settings
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Ctrl-P stuff
set runtimepath^=~/.vim/bundle/ctrlp.vim
set wildignore+=*.class,*.o,*.a,*.pyc
let g:ctrlp_custom_ignore= '\v(.*[\/](node_modules|doc|build|bin|gen|res)[\/].*)|(*.(o|class))'
let g:ctrlp_show_hidden=1

" Vim markdown preview configurations
let vim_markdown_preview_hotkey='<C-m>'
let vim_markdown_preview_browser='Google Chrome'


""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   ColorScheme and Their Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

set background=dark

colorscheme catppuccin " catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha

"let g:gruvbox_contrast_dark="hard"
"colorscheme gruvbox
"let g:airline_theme = 'gruvbox'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   Other Configurations
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntax highlighting for groovy (Jenkinsfiles)
autocmd BufNewFile,BufRead Jenkinsfile set syntax=groovy
