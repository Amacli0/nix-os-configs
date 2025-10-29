-- ═══════════════════════════════════════════════════════════
-- 🔧 DİĞER PLUGIN YAPLANDIRMALARI
-- ═══════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────
-- 📊 Lualine (Status Bar)
-- ───────────────────────────────────────────────────────────

require('lualine').setup({
  options = {
    theme = 'catppuccin',
    component_separators = '|',
    section_separators = '',
  },
})

-- ───────────────────────────────────────────────────────────
-- 💬 Comment.nvim (Kolay Yorum Satırı)
-- ───────────────────────────────────────────────────────────

require('Comment').setup()
-- gcc: Satırı yorum yap
-- gbc: Block yorum

-- ───────────────────────────────────────────────────────────
-- 🌿 Gitsigns (Git İşaretleri)
-- ───────────────────────────────────────────────────────────

require('gitsigns').setup({
  signs = {
    add = { text = '│' },
    change = { text = '│' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
})

-- ───────────────────────────────────────────────────────────
-- ⌨️  Which-Key (Tuş Kılavuzu)
-- ───────────────────────────────────────────────────────────

require('which-key').setup({
  window = {
    border = 'rounded',
  },
})

-- ───────────────────────────────────────────────────────────
-- 📏 Indent Blankline (Girinti Çizgileri)
-- ───────────────────────────────────────────────────────────

require('ibl').setup({
  indent = {
    char = '│',
  },
  scope = {
    enabled = true,
  },
})

-- ───────────────────────────────────────────────────────────
-- ⚡ Impatient (Daha Hızlı Başlatma)
-- ───────────────────────────────────────────────────────────

require('impatient')
