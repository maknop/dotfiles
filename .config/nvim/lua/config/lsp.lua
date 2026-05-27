-- LSP Configuration
-- Get default capabilities from nvim-cmp
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Golang LSP
vim.lsp.config.gopls = {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_markers = { 'go.work', 'go.mod', '.git' },
  capabilities = capabilities,
}

-- Python LSP - Ruff (Might need to run pip install ruff-lsp)
vim.lsp.config.ruff = {
  cmd = { 'ruff', 'server' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', '.git' },
  capabilities = capabilities,
}

-- Python LSP - Pyright (Might need to pip install pyright)
vim.lsp.config.pyright = {
  cmd = { 'pyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', '.git' },
  capabilities = capabilities,
}

-- TypeScript LSP (Might need to run npm install -g typescript typescript-language-server)
vim.lsp.config.ts_ls = {
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = { 'javascript', 'typescript', 'typescriptreact', 'typescript.tsx' },
  root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' },
  capabilities = capabilities,
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = vim.fn.trim(vim.fn.system('npm root -g')) .. '/@vue/typescript-plugin',
        languages = {"javascript", "typescript", "vue"},
      },
    },
  },
}

-- Enable LSP servers
vim.lsp.enable('gopls')
vim.lsp.enable('ruff')
vim.lsp.enable('pyright')
vim.lsp.enable('ts_ls')
