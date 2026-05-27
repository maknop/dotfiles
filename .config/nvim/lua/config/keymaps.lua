-- Key mappings
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Line navigation keys
keymap("n", "j", "gj", opts)
keymap("n", "k", "gk", opts)
keymap("n", "H", "^", opts)
keymap("n", "L", "$", opts)

-- Rebind back a word keys
keymap("n", "w", "b", opts)

-- Change windows with <C-movement>
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Copying to system clipboard
keymap("v", "<C-c>", '"+y', opts)

-- Toggle paste mode
keymap("n", "<C-p>", ":set paste!<CR>", opts)

-- Entering command mode with ; instead of :
keymap("n", ";", ":", opts)

-- Exiting insert mode
keymap("i", "jk", "<ESC>", opts)
keymap("i", "JK", "<ESC>", opts)

-- NvimTree mappings (will work when plugin is loaded)
keymap("n", "<C-n>", "<cmd>NvimTreeToggle<cr>", opts)
keymap("n", "<C-m>", "<cmd>NvimTreeFindFile<cr>", opts)

-- Telescope mappings
keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)
keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts)
keymap("n", "<leader>r", "<cmd>lua require('telescope.builtin').oldfiles()<cr>", opts)
