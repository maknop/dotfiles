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
Plug 'sainnhe/everforest'
Plug 'kaicataldo/material.vim', { 'branch': 'main' }
Plug 'AlexvZyl/nordic.nvim', { 'branch': 'main' }

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
Plug 'jiangmiao/auto-pairs'           " Insert or delete brackets, parents, quotes in pair
Plug 'vim-airline/vim-airline'        "Vim airline
Plug 'jdhao/whitespace.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
" or                                , { 'branch': '0.1.x' }

" nvim autocompletion
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

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
set relativenumber

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
" Change <Leader> key
let mapleader = ","

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
map <C-m> :NERDTreeFind<CR>

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>


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
"   Colorscheme and Their Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('termguicolors')
  set termguicolors
endif

" For dark version.
set background=dark

"colorscheme catppuccin " catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha

"let g:material_terminal_italics = 1
"let g:material_theme_style = 'ocean'
"colorscheme material
"let g:airline_theme = 'material'

colorscheme nordic


""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" nvim-cmp Configurations
""""""""""""""""""""""""""""""""""""""""""""""""""""""""
lua <<EOF
  -- Set up nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
  -- Set configuration for specific filetype.
  --[[ cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' },
    }, {
      { name = 'buffer' },
    })
 })
 require("cmp_git").setup() ]]-- 

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
  })

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()

  -- Golang
  require('lspconfig')['gopls'].setup {
    capabilities = capabilities
  }

  -- Python (Might need to run pip install ruff-lsp)
  require('lspconfig')['ruff'].setup {
    capabilities = capabilities
  }
  
  -- Python (Might need to pip install pyright)
  require('lspconfig')['pyright'].setup {
    capabilities = capabilities
  }

  -- TypeScript (Might need to run npm install -g typescript typescript-language-server)
  require('lspconfig')['ts_ls'].setup {
    init_options = {
      plugins = {
        {
          name = "@vue/typescript-plugin",
          location = "/usr/local/lib/node_modules/@vue/typescript-plugin",
          languages = {"javascript", "typescript", "vue"},
        },
      },
    },
    filetypes = {
      "javascript",
      "typescript",
      "typescriptreact",
      "typescript.tsx"
    },
  }
EOF
