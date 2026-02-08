-- Autocommands
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- NvimTree: close vim if nvim-tree is the only window left
autocmd("BufEnter", {
  group = augroup("NvimTreeClose", { clear = true }),
  pattern = "NvimTree_*",
  callback = function()
    local layout = vim.api.nvim_call_function("winlayout", {})
    if layout[1] == "leaf" and vim.bo[vim.api.nvim_win_get_buf(layout[2])].filetype == "NvimTree" and layout[3] == nil then
      vim.cmd("quit")
    end
  end,
})

-- Markdown preview settings
vim.g.vim_markdown_preview_hotkey = '<C-m>'
