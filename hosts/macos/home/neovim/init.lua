-- ===================================
-- Neovim init.lua (Home Manager)
-- ===================================

-- 1. Allgemeine Optionen
vim.o.termguicolors = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.updatetime = 300 -- Schnelleres Schreiben von swap-Dateien

-- 2. Theme Setup (Catppuccin)
vim.cmd.colorscheme('catppuccin')
vim.cmd [[
  hi NvimTreeNormal guibg=none ctermbg=none
  hi Normal guibg=none ctermbg=none
]]

-- 3. nvim-treesitter Setup
require('nvim-treesitter.configs').setup {
  ensure_installed = "all", -- Installiert alle von Nix bereitgestellten Grammatiken
  highlight = { enable = true },
  indent = { enable = true },
}

-- 4. nvim-tree (Datei-Explorer) Setup
require('nvim-tree').setup {
  sort_by = "case_sensitive",
  view = {
    width = 30,
  },
  git = {
    enable = true,
  },
  actions = {
    open_file = {
      quit_on_open = true,
    },
  },
}

-- 5. lualine Setup (Statuszeile)
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'catppuccin',
    component_separators = '|',
    section_separators = '',
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff'},
    lualine_c = {'filename', 'lsp_progress'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'},
  }
}

-- 6. Keymaps für IT Sensei-Workflow
local map = vim.api.nvim_set_keymap
local default_opts = { noremap = true, silent = true }

-- Dateibrowser
map('n', '<leader>e', ':NvimTreeToggle<CR>', default_opts)

-- Telescope (Fuzzy Finder)
map('n', '<leader>ff', ':Telescope find_files<CR>', default_opts)
map('n', '<leader>fg', ':Telescope live_grep<CR>', default_opts)

-- LSP (Code Navigation)
map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', default_opts)
map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', default_opts)
map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', default_opts)

-- Speichern
map('n', '<C-s>', ':w<CR>', default_opts)
