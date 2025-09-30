-- Colorscheme configuration
-- This function safely sets a colorscheme with fallback

local M = {}

-- Set colorscheme with fallback
function M.setup()
  local colorscheme = "everforest"
  
  -- Try to set the colorscheme directly
  local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
  if not status_ok then
    -- Fallback to default if colorscheme not found
    vim.notify("Colorscheme " .. colorscheme .. " not found! Using default.", vim.log.levels.WARN)
    vim.cmd("colorscheme default")
  end
end

return M
