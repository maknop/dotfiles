-- Colorscheme configuration
-- This function safely sets a colorscheme with fallback

local M = {}

-- Set colorscheme with fallback
function M.setup()
  local colorscheme = "everforest"
  
  -- Configure everforest before setting it
  if colorscheme == "everforest" then
    -- Set everforest options for better terminal compatibility
    vim.g.everforest_better_performance = 1
    vim.g.everforest_background = "soft"  -- soft, medium, hard
    vim.g.everforest_ui = "auto"  -- auto, dark, light
    vim.g.everforest_transparent_background = 0
    vim.g.everforest_show_eob = 1
    vim.g.everforest_diagnostic_text_highlight = 0
    vim.g.everforest_diagnostic_line_highlight = 1
    vim.g.everforest_diagnostic_virtual_text = "colored"
    vim.g.everforest_current_word = "grey background"
    vim.g.everforest_spell_foreground = "colored"
    vim.g.everforest_cursor = "auto"
    vim.g.everforest_lsp = 1
    vim.g.everforest_pumblend = 0
    vim.g.everforest_float_style = "dim"
    vim.g.everforest_italic_keywords = 1
    vim.g.everforest_italic_functions = 0
    vim.g.everforest_italic_comments = 1
    vim.g.everforest_italic_loops = 0
    vim.g.everforest_italic_conditionals = 0
    vim.g.everforest_italic_variables = 0
    vim.g.everforest_italic_math = 0
    vim.g.everforest_italic_emphasis = 1
    vim.g.everforest_italic_operators = 0
    vim.g.everforest_italic_strings = 0
    vim.g.everforest_italic_vectors = 0
    vim.g.everforest_italic_parameters = 0
    vim.g.everforest_italic_types = 0
    vim.g.everforest_italic_fields = 0
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