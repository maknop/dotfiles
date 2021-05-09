"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   Plugins - General 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Setting up Vundle
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Color schemes
Plugin 'altercation/vim-colors-solarized'
Plugin 'morhetz/gruvbox'

" NERDTree -- File browser in vim
Plugin 'scrooloose/nerdtree'

" NERDcommenter -- Auto comment out lines
Plugin 'scrooloose/nerdcommenter'

" Ctlr-P Stuff
Plugin 'kien/ctrlp.vim'

" Insert or delete brackets, parens, quotes in pair
Plugin 'jiangmiao/auto-pairs'

Plugin 'Rainbow-Parenthesis'

" vim-airline
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" Markdown preview
Plugin 'JamshedVesuna/vim-markdown-preview'

" Vim Personal Wiki
Plugin 'vimwiki/vimwiki'

" Proper pep8 indents for python
Plugin 'hynek/vim-python-pep8-indent'   " Python 

" Auto-complete tags in html
Plugin 'alvan/vim-closetag'             " HTML

" Better CSS Highlighting for Vim
Plugin 'hail2u/vim-css3-syntax'         " CSS

"Beautifier for JavaScript
Plugin 'beautify-web/js-beautify'       " JavaScript

" Javascript indentation help
Plugin 'JavaScript-Indent'              " JavaScript

" JSX Syntax Highlighting
Plugin 'pangloss/vim-javascript'        " React JS
Plugin 'mxw/vim-jsx'

" Auto-complete for Java
Plugin 'artur-shaik/vim-javacomplete2'  " Java

" Go development plugin for Vim
Plugin 'fatih/vim-go'                   "Golang

"Required for Vundle
call vundle#end()    

" :source %
" Type PluginInstall


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

" Flutter key mapping
nnoremap <leader>fa :FlutterRun<cr>
nnoremap <leader>fq :FlutterQuit<cr>
nnoremap <leader>fr :FlutterHotReload<cr>
nnoremap <leader>fR :FlutterHotRestart<cr>
nnoremap <leader>fD :FlutterVisualDebug<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   General/Plugin Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on
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

" FZF commands
let g:fzf_action = {
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit'
      \ }
nnoremap <c-p> :Files<cr>
augroup fzf
  autocmd!
  autocmd! FileType fzf
  autocmd  FileType fzf set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
augroup END

" Vim markdown preview configurations
let vim_markdown_preview_hotkey='<C-m>'
let vim_markdown_preview_browser='Google Chrome'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   ColorScheme and Their Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set background=dark
"colorscheme onedark
"colorscheme solarized

colorscheme gruvbox
let g:gruvbox_contrast_dark="soft"

