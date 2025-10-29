-- Leader tuşunu ayarla (ÖNCE TANIMLA!)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- ═══════════════════════════════════════════════════════════
-- 🎨 GÖRÜNÜM AYARLARI
-- ═══════════════════════════════════════════════════════════

vim.opt.number = true              -- Satır numaraları
vim.opt.relativenumber = true      -- Relative numaralar
vim.opt.signcolumn = 'yes'         -- LSP işaretleri için kolon
vim.opt.cursorline = true          -- Mevcut satırı vurgula
vim.opt.termguicolors = true       -- 24-bit renkler

-- ═══════════════════════════════════════════════════════════
-- 📝 DÜZENLEYİCİ AYARLARI
-- ═══════════════════════════════════════════════════════════

vim.opt.mouse = 'a'                -- Mouse desteği
vim.opt.clipboard = 'unnamedplus'  -- Sistem clipboard'unu kullan
vim.opt.undofile = true            -- Undo geçmişini kaydet
vim.opt.ignorecase = true          -- Aramada büyük/küçük harf duyarsız
vim.opt.smartcase = true           -- Büyük harf varsa duyarlı ol
vim.opt.updatetime = 250           -- Daha hızlı güncelleme
vim.opt.timeoutlen = 300           -- Tuş kombinasyonu bekleme süresi
vim.opt.splitright = true          -- Vertical split sağda açılsın
vim.opt.splitbelow = true          -- Horizontal split altta açılsın

-- ═══════════════════════════════════════════════════════════
-- 📐 GİRİNTİ AYARLARI
-- ═══════════════════════════════════════════════════════════

vim.opt.tabstop = 2                -- Tab genişliği
vim.opt.shiftwidth = 2             -- Indent genişliği
vim.opt.expandtab = true           -- Tab'ı boşluğa çevir
vim.opt.smartindent = true         -- Akıllı girintileme

-- ═══════════════════════════════════════════════════════════
-- ⚡ PERFORMANS
-- ═══════════════════════════════════════════════════════════

vim.opt.lazyredraw = true          -- Macro sırasında ekranı güncelleme
vim.opt.synmaxcol = 240            -- Uzun satırlarda syntax sınırla

-- ═══════════════════════════════════════════════════════════
-- 🎨 TEMA
-- ═══════════════════════════════════════════════════════════

require('catppuccin').setup({
  flavour = 'mocha',  -- latte, frappe, macchiato, mocha
  transparent_background = false,
  integrations = {
    cmp = true,
    gitsigns = true,
    telescope = true,
    treesitter = true,
  }
})
vim.cmd.colorscheme 'catppuccin'

-- ═══════════════════════════════════════════════════════════
-- 🔧 PLUGIN YAPLANDIRMALARI
-- ═══════════════════════════════════════════════════════════

-- Diğer plugin yapılandırmalarını yükle
require('plugin.lsp')
require('plugin.cmp')
require('plugin.treesitter')
require('plugin.telescope')
require('plugin.other')
