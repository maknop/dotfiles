-- Colorscheme configuration
-- This function safely sets a colorscheme with fallback

local M = {}

-- Set colorscheme with fallback
function M.setup()
  local colorscheme = "everforest"

  -- Configure everforest before setting it
  if colorscheme == "everforest" then
    require('everforest').setup({
      -- Control the "hardness" of the background (soft, medium, hard)
      background = "medium",
      -- How much of the background should be transparent
      transparent_background_level = 0,
      -- Use italic for comments
      italics = true,
      -- Disable italic for keywords
      disable_italic_comments = false,
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
