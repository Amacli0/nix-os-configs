-- ═══════════════════════════════════════════════════════════
-- 💬 AUTO-COMPLETION (nvim-cmp)
-- ═══════════════════════════════════════════════════════════

local cmp = require('cmp')
local luasnip = require('luasnip')

-- Hazır snippet'leri yükle
require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup({
  -- Snippet engine
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  
  -- ═══════════════════════════════════════════════════════════
  -- ⌨️  TUŞ KISAYOLLARI
  -- ═══════════════════════════════════════════════════════════
  
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Enter ile kabul et
    
    -- Tab ile snippet'lerde gezin
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  
  -- ═══════════════════════════════════════════════════════════
  -- 📋 KAYNAKLAR (Completion Sources)
  -- ═══════════════════════════════════════════════════════════
  
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },   -- LSP
    { name = 'luasnip' },    -- Snippet'ler
    { name = 'buffer' },     -- Açık dosyalardaki kelimeler
    { name = 'path' },       -- Dosya yolları
  }),
  
  -- ═══════════════════════════════════════════════════════════
  -- 🎨 GÖRÜNÜM
  -- ═══════════════════════════════════════════════════════════
  
  formatting = {
    format = function(entry, item)
      -- Kaynak adını göster
      item.menu = ({
        nvim_lsp = '[LSP]',
        luasnip = '[Snippet]',
        buffer = '[Buffer]',
        path = '[Path]',
      })[entry.source.name]
      return item
    end,
  },
  
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
})

-- ═══════════════════════════════════════════════════════════
-- 🔍 KOMUT SATIRI COMPLETION
-- ═══════════════════════════════════════════════════════════

-- `/` arama için
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- `:` komutlar için
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})
