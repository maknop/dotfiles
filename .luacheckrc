-- luacheck configuration for Neovim Lua config
-- https://luacheck.readthedocs.io/en/stable/config.html

std = "lua51"

-- Neovim's vim global
globals = { "vim" }

-- Long lines are common in plugin config tables
max_line_length = false
