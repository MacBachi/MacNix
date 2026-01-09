-- ===================================
-- Neovim init.lua (Home Manager)
-- ===================================

--  Allgemeine Optionen
vim.o.termguicolors = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.updatetime = 300 -- Schnelleres Schreiben von swap-Dateien


vim.api.nvim_set_keymap('v', '<C-c>', '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-v>', '"+p', { noremap = true, silent = true })


-- Theme Setup (Catppuccin)
vim.cmd.colorscheme('catppuccin')
vim.cmd [[
  hi NvimTreeNormal guibg=none ctermbg=none
  hi Normal guibg=none ctermbg=none
]]

-- nvim-treesitter Setup
require('nvim-treesitter').setup {
  highlight = { enable = true },
  indent = { enable = true },
}



require('gitsigns').setup {
  -- Emojis für die verschiedenen Git-Status
  signs = {
    add          = { text = '➕' }, -- Hinzugefügte Zeile
    change       = { text = '🟡' }, -- Geänderte Zeile
    delete       = { text = '➖' }, -- Gelöschte Zeile (wird in der Zeile darüber angezeigt)
    topdelete    = { text = '❌' }, -- Oberste gelöschte Zeile
    changedelete = { text = '⚡️' }, -- Geändert und gelöscht
    untracked    = { text = '❔' }, -- Nicht verfolgte Zeile
  },

  signcolumn = true, -- Aktiviert die Zeichenspalte (zeigt Emojis)
  numhl = true,      -- AKTIVIERT die spezielle Hervorhebung der GEÄNDERTEN Zeilennummern
  linehl = false,    -- Deaktiviert die Hervorhebung der gesamten Zeile (optional)
  word_diff = true,  -- AKTIVIERT die Hervorhebung von Wort-Unterschieden in der Zeile

-- Einbindung von Keymaps (Sensei Navigation)
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    
    -- Leet-Keymaps für die Navigation
    -- [g (Previous Hunk), ]g (Next Hunk)
    vim.keymap.set('n', '[g', gs.prev_hunk, { buffer = bufnr, desc = 'Git: Previous Change Hunk' })
    vim.keymap.set('n', ']g', gs.next_hunk, { buffer = bufnr, desc = 'Git: Next Change Hunk' })

    -- Stage/Reset Actions
    vim.keymap.set('n', '<leader>gs', gs.stage_hunk, { buffer = bufnr, desc = 'Git: Stage Hunk' }) -- Hunk stagen
    vim.keymap.set('n', '<leader>gr', gs.reset_hunk, { buffer = bufnr, desc = 'Git: Reset Hunk' }) -- Hunk zurücksetzen
    
    -- Textobjekt-Mapping (visuell)
    vim.keymap.set({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { buffer = bufnr, desc = 'Git: Select Hunk' })
  end,

}
  


--  indent-blankline
require("ibl").setup {
  -- ... Konfiguration für die Einrückungslinien ...
}

-- e) dashboard-nvim
require('dashboard').setup {
  theme = 'hyper', -- Beispiel-Theme
  config = {
	center = {
      { icon = '👀', desc = ' Find Files (Telescope)', action = 'Telescope find_files', key = 'f' },
      { icon = '🔎', desc = ' Grep Code (RipGrep)', action = 'Telescope live_grep', key = 'g' },
      { icon = '💬', desc = ' Toggle Terminal', action = 'Toggleterm', key = 't' },
      { icon = '♻️', desc = ' Session Restore', action = 'RestoreSession', key = 's' },
      { icon = '🏥', desc = ' Health Check (LSP)', action = 'checkhealth lsp', key = 'h' },
      { icon = '😩', desc = ' Quit Neovim', action = 'qa', key = 'q' },

    shortcut = 'c',
    },
  },
}

--  nvim-tree (Datei-Explorer) Setup
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


vim.api.nvim_create_autocmd("BufEnter", {
      group = vim.api.nvim_create_augroup("DashboardFix", { clear = true }),
      pattern = "dashboard",
      callback = function()
        if vim.g.ibl_started then
              vim.cmd("IndentBlanklineDisable")
        end
  end,
})
