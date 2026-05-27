-- General Neovim options
local opt = vim.opt
local g = vim.g

-- Leader key
g.mapleader = ","

-- General settings
opt.encoding = "utf-8"
opt.scrolloff = 5
opt.showmode = true                    -- Display current mode
opt.ruler = true                       -- Show line and column of position
opt.number = true
opt.relativenumber = true
opt.backspace = { "indent", "eol", "start" }
opt.swapfile = false                   -- Disable swap files
opt.mouse = "a"

-- Indentation and formatting
opt.tabstop = 4                        -- Indent to four spaces
opt.shiftwidth = 4
opt.expandtab = true                   -- Spaces, not tabs
opt.autoindent = true
opt.smartindent = true
opt.wrap = true                        -- Lines wrap
opt.cursorcolumn = true                -- Column cursorline

-- Search settings
opt.ignorecase = true                  -- Ignore case when searching

-- Enable syntax and filetype detection
vim.cmd("syntax enable")
vim.cmd("filetype plugin indent on")

-- Terminal colors
if vim.fn.exists('+termguicolors') == 1 then
  vim.env.t_8f = "\27[38;2;%lu;%lu;%lum"
  vim.env.t_8b = "\27[48;2;%lu;%lu;%lum"
  opt.termguicolors = true
end

opt.background = "dark"

-- Colorscheme will be set after plugins are loaded
