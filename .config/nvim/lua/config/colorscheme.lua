-- Colorscheme configuration
-- This function safely sets a colorscheme with fallback

local M = {}

-- Set colorscheme with fallback
function M.setup()
  local colorscheme = "nordic"

  -- Configure nordic before setting it
  if colorscheme == "nordic" then
    require('nordic').setup({
      -- Use a more prominent cursorline
      cursorline = {
        bold = false,
        bold_number = true,
        theme = 'dark',
        blend = 0.85,
      },
      -- Configure bold and italic styles
      bold_keywords = false,
      italic_comments = true,
      -- Reduce overall brightness
      reduced_blue = false,
      -- Use brighter colors for syntax
      bright_border = false,
      -- Styling options
      noice = {
        style = 'classic',
      },
      telescope = {
        style = 'classic',
      },
    })
  end
  
  -- Try to set the colorscheme directly
  local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
  if not status_ok then
    -- Fallback to default if colorscheme not found
    vim.notify("Colorscheme " .. colorscheme .. " not found! Using default.", vim.log.levels.WARN)
    vim.cmd("colorscheme default")
  end
  
  -- Configure statusline to reflect current theme
  local statusline_ok, statusline = pcall(require, "config.statusline")
  if statusline_ok then
    statusline.setup()
  end
end

return M
