-- Colorscheme configuration
-- This function safely sets a colorscheme with fallback

local M = {}

-- Set colorscheme with fallback
function M.setup()
  local colorscheme = "nordic"
  
  -- Configure Nordic theme with custom options
  local nordic_ok, nordic = pcall(require, "nordic")
  if nordic_ok then
    nordic.setup({
      bold_keywords = false,
      italic_comments = true,
      transparent = {
        bg = false,
        float = false,
      },
      bright_border = false,
      reduced_blue = true,
      swap_backgrounds = false,
      cursorline = {
        bold = false,
        bold_number = true,
        theme = 'dark',
        blend = 0.85,
      },
      noice = {
        style = 'classic',
      },
      telescope = {
        style = 'flat',
      },
      leap = {
        dim_backdrop = false,
      },
      ts_context = {
        dark_background = true,
      }
    })
    -- Load Nordic theme
    nordic.load()
  else
    -- Try to set the colorscheme directly
    local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
    if not status_ok then
      -- Fallback to default if colorscheme not found
      vim.notify("Colorscheme " .. colorscheme .. " not found! Using default.", vim.log.levels.WARN)
      vim.cmd("colorscheme default")
    end
  end
  
  -- Configure statusline to reflect current theme
  local statusline_ok, statusline = pcall(require, "config.statusline")
  if statusline_ok then
    statusline.setup()
  end
end

return M
