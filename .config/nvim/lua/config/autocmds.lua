-- Autocommands
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- NERDTree settings - close vim if NERDTree is the only window left
autocmd("BufEnter", {
  group = augroup("NERDTreeClose", { clear = true }),
  pattern = "*",
  callback = function()
    if vim.fn.winnr("$") == 1 and vim.fn.exists("b:NERDTreeType") == 1 and vim.b.NERDTreeType == "primary" then
      vim.cmd("q")
    end
  end,
})

-- Markdown preview settings
vim.g.vim_markdown_preview_hotkey = '<C-m>'
vim.g.vim_markdown_preview_browser = 'Google Chrome'
