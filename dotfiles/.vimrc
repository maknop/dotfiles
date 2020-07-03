"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   Plugins - General 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Setting up Vundle
filetype off
set rtp+=~/.vim/bundle/vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" NERDTree -- File browser in vim
Plugin 'scrooloose/nerdtree'

" NERDcommenter -- Auto comment out lines
Plugin 'scrooloose/nerdcommenter'

" Ctlr-P Stuff
Plugin 'kien/ctrlp.vim'

" Colorschemes
Plugin 'relastle/bluewery.vim'

" Installs fzf
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }

call vundle#end()    
" Type PluginInstall


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   Plugins - Python Programming
""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Proper pep8 indents for python
Bundle 'hynek/vim-python-pep8-indent'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible                " vim, not vi
set encoding=utf-8
set scrolloff=5             
set showmode                    " Displays current mode
set ruler                       " Shows line and column of position
set number                  
set relativenumber              " Show line number relative to current line
set backspace=indent,eol,start

fixdel                          " Better functionality for delete key

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

" Change windows with <C-movement>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
noremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Copying to system clipboard
vnoremap <C-c> "+y

" Toggle paste mode
nnoremap <C-p> :set paste!<cr>

" Entering command mode with ; instead of :
nnoremap ; :

" Exiting insert mode
inoremap jj <ESC>
inoremap JJ <ESC>

nnoremap <leader>n :NERDTreeToggle<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   Settings for Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"let &t_Co=256
syntax on

highlight Normal ctermbg=None
highlight LineNr ctermfg=DarkGrey

filetype plugin indent on
filetype plugin on

" Nerdtree settings
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Ctrl-P stuff
set runtimepath^=~/.vim/bundle/ctrlp.vim
set wildignore+=*.class,*.o,*.a,*.pyc
let g:ctrlp_custom_ignore= '\v(.*[\/](node_modules|doc|build|bin|gen|res)[\/].*)|(*.(o|class))'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   ColorScheme and Their Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
colorscheme onedark
"colorscheme citylights
" For dark
"colorscheme bluewery
"let g:lightline = { 'colorscheme': 'bluewery' }

" For light
"colorscheme bluewery-light
"let g:lightline = { 'colorscheme': 'bluewery_light' }


