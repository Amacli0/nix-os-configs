-- Leader tuşunu ayarla (ÖNCE TANIMLA!)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- ═══════════════════════════════════════════════════════════
-- 🎨 GÖRÜNÜM AYARLARI
-- ═══════════════════════════════════════════════════════════

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes'
vim.opt.cursorline = true
vim.opt.termguicolors = true

-- ═══════════════════════════════════════════════════════════
-- 📝 DÜZENLEYİCİ AYARLARI
-- ═══════════════════════════════════════════════════════════

vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true

-- ═══════════════════════════════════════════════════════════
-- 📐 GİRİNTİ AYARLARI
-- ═══════════════════════════════════════════════════════════

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- ═══════════════════════════════════════════════════════════
-- ⚡ PERFORMANS
-- ═══════════════════════════════════════════════════════════

vim.opt.lazyredraw = true
vim.opt.synmaxcol = 240

-- ═══════════════════════════════════════════════════════════
-- 🎨 TEMA
-- ═══════════════════════════════════════════════════════════

require('catppuccin').setup({
  flavour = 'mocha',
  transparent_background = false,
  integrations = {
    cmp = true,
    gitsigns = true,
    telescope = true,
    treesitter = true,
  }
})
vim.cmd.colorscheme 'catppuccin'
