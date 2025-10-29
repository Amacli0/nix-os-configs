-- ═══════════════════════════════════════════════════════════
-- 🌳 TREESITTER (Modern Syntax Highlighting)
-- ═══════════════════════════════════════════════════════════

require('nvim-treesitter.configs').setup({
  -- Highlight'ı etkinleştir
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  
  -- Indent'i etkinleştir
  indent = {
    enable = true,
  },
  
  -- Akıllı metin objeleri
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
  },
})
