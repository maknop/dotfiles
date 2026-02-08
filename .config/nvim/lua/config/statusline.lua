-- Statusline configuration that reflects the current theme
local M = {}

-- Check if tmux is active
function M.is_tmux_active()
  return vim.env.TMUX ~= nil
end

-- Get current theme
function M.get_current_theme()
  local colorscheme = vim.g.colors_name or "default"
  return colorscheme
end

-- Configure airline theme based on current colorscheme
function M.setup()
  -- Check if tmux is active
  if M.is_tmux_active() then
    -- Disable statusline when tmux is active
    vim.opt.laststatus = 0
    vim.g.airline_disable_statusline = 1
    return
  end

  -- Enable statusline when not in tmux
  vim.opt.laststatus = 2
  vim.g.airline_disable_statusline = 0

  local theme = M.get_current_theme()
  
  if theme == "nordic" then
    -- Nordic theme configuration
    vim.g.airline_theme = "nord"
    vim.g.airline_powerline_fonts = 1
    vim.g.airline_symbols = {
      branch = "",
      colnr = " ㏇:",
      linenr = " ㏈:",
      maxlinenr = "☰",
      modified = " ●",
      paste = " PASTE",
      readonly = " ",
      whitespace = "  "
    }
  elseif theme == "everforest" then
    -- Everforest theme configuration
    vim.g.airline_theme = "everforest"
    vim.g.airline_powerline_fonts = 1
    vim.g.airline_symbols = {
      branch = "",
      colnr = " ㏇:",
      linenr = " ㏈:",
      maxlinenr = "☰",
      modified = " ●",
      paste = " PASTE",
      readonly = " ",
      whitespace = "  "
    }
  else
    -- Default configuration
    vim.g.airline_theme = "default"
    vim.g.airline_powerline_fonts = 1
  end

  -- Common airline settings
  vim.g["airline#extensions#tabline#enabled"] = 1
  vim.g["airline#extensions#tabline#left_sep"] = ' '
  vim.g["airline#extensions#tabline#left_alt_sep"] = '|'
  vim.g["airline#extensions#tabline#right_sep"] = ' '
  vim.g["airline#extensions#tabline#right_alt_sep"] = '|'
  
  -- Show current theme in statusline
  vim.g.airline_section_x = '%{g:airline_symbols.colnr}%{col(".")}%{g:airline_symbols.linenr}%{line(".")}%{g:airline_symbols.maxlinenr}%{line("$")} | Theme: ' .. theme
end

return M
