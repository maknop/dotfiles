-- LSP Configuration
local lspconfig = require('lspconfig')

-- Get default capabilities from nvim-cmp
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Golang LSP
lspconfig.gopls.setup {
  capabilities = capabilities,
}

-- Python LSP - Ruff (Might need to run pip install ruff-lsp)
lspconfig.ruff.setup {
  capabilities = capabilities,
}

-- Python LSP - Pyright (Might need to pip install pyright)
lspconfig.pyright.setup {
  capabilities = capabilities,
}

-- TypeScript LSP (Might need to run npm install -g typescript typescript-language-server)
lspconfig.ts_ls.setup {
  capabilities = capabilities,
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = "/usr/local/lib/node_modules/@vue/typescript-plugin",
        languages = {"javascript", "typescript", "vue"},
      },
    },
  },
  filetypes = {
    "javascript",
    "typescript",
    "typescriptreact",
    "typescript.tsx"
  },
}
