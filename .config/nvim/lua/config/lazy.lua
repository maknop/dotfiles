-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  -- Color schemes
  {
    "morhetz/gruvbox",
    lazy = true,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
  },
  {
    "neanias/everforest-nvim",
    priority = 1000,
    config = function()
      require("config.colorscheme").setup()
    end,
  },
  {
    "kaicataldo/material.vim",
    lazy = true,
  },
  {
    "AlexvZyl/nordic.nvim",
    priority = 1000,
    config = function()
      require("config.colorscheme").setup()
    end,
  },
  {
    "glepnir/oceanic-material",
    lazy = true,
  },
  {
    "neanias/everforest-nvim",
    lazy = true,
  },

  -- Markdown preview
  {
    "JamshedVesuna/vim-markdown-preview",
    ft = "markdown",
  },

  -- Vim Personal Wiki
  {
    "vimwiki/vimwiki",
    ft = "vimwiki",
  },

  -- Language-specific plugins
  {
    "hynek/vim-python-pep8-indent",
    ft = "python",
  },
  {
    "alvan/vim-closetag",
    ft = { "html", "xml", "jsx", "tsx" },
  },
  {
    "hail2u/vim-css3-syntax",
    ft = "css",
  },
  {
    "beautify-web/js-beautify",
    ft = { "javascript", "json", "html", "css" },
  },
  {
    "pangloss/vim-javascript",
    ft = "javascript",
  },
  {
    "mxw/vim-jsx",
    ft = { "jsx", "javascript.jsx" },
  },
  {
    "fatih/vim-go",
    ft = "go",
  },

  -- Core plugins
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<C-n>", "<cmd>NvimTreeToggle<cr>", desc = "Toggle NvimTree" },
      { "<C-m>", "<cmd>NvimTreeFindFile<cr>", desc = "Find file in NvimTree" },
    },
    config = function()
      require("nvim-tree").setup({
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
          },
        },
        filters = {
          dotfiles = false,
        },
        git = {
          enable = true,
          ignore = false,
        },
        actions = {
          open_file = {
            quit_on_open = false,
          },
        },
      })
    end,
  },
  {
    "scrooloose/nerdcommenter",
    keys = { "<leader>c" },
  },
  {
    "jiangmiao/auto-pairs",
    event = "InsertEnter",
  },
  {
    "vim-airline/vim-airline",
    event = "VeryLazy",
  },
  {
    "christoomey/vim-tmux-navigator",
    keys = { "<C-h>", "<C-j>", "<C-k>", "<C-l>" },
  },

  -- Telescope and dependencies
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>" },
      { "<leader>r", "<cmd>lua require('telescope.builtin').oldfiles()<cr>" },
    },
  },

  -- Noice and dependencies
  {
    "MunifTanjim/nui.nvim",
    lazy = true,
  },
  {
    "rcarriga/nvim-notify",
    lazy = true,
  },
  {
    "folke/noice.nvim",
    enabled = false,
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("config.noice")
    end,
  },

  -- Treesitter for better syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "vim", "regex", "lua", "bash", "markdown", "markdown_inline" },
        highlight = {
          enable = true,
        },
      })
    end,
  },

  -- LSP and completion
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("config.lsp")
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
    },
    config = function()
      require("config.cmp")
    end,
  },

  -- Completion sources
  {
    "hrsh7th/cmp-nvim-lsp",
    lazy = true,
  },
  {
    "hrsh7th/cmp-buffer",
    lazy = true,
  },
  {
    "hrsh7th/cmp-path",
    lazy = true,
  },
  {
    "hrsh7th/cmp-cmdline",
    lazy = true,
  },
}, {
  -- Lazy.nvim configuration
  install = {
    colorscheme = { "catppuccin", "default" },
  },
  checker = {
    enabled = true,
  },
})
