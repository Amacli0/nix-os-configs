-- ═══════════════════════════════════════════════════════════
-- 🔌 LSP (Language Server Protocol) YAPLANDIRMASI
-- ═══════════════════════════════════════════════════════════

local lspconfig = require('lspconfig')

-- LSP loading progress göstergesi
require('fidget').setup({})

-- LSP attach olduğunda çalışacak fonksiyon
local on_attach = function(client, bufnr)
  -- Tuş kısayolları sadece bu buffer için geçerli
  local opts = { buffer = bufnr, noremap = true, silent = true }
  
  -- ═══════════════════════════════════════════════════════════
  -- ⌨️  TUŞ KISAYOLLARI
  -- ═══════════════════════════════════════════════════════════
  
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)          -- Tanıma git
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)         -- Bildirime git
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)          -- Referanslar
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)      -- İmplementasyon
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)                -- Hover dokümantasyon
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)   -- İmza yardımı
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)      -- Yeniden adlandır
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts) -- Code action
  vim.keymap.set('n', '<leader>f', function()
    vim.lsp.buf.format({ async = true })
  end, opts)                                                        -- Format
  
  -- Diagnostics (hata mesajları)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)        -- Önceki hata
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)        -- Sonraki hata
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)-- Hatayı göster
end

-- ═══════════════════════════════════════════════════════════
-- 🔧 LSP CAPABILITIES (Completion Desteği)
-- ═══════════════════════════════════════════════════════════

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- ═══════════════════════════════════════════════════════════
-- 📋 DIL SUNUCULARI
-- ═══════════════════════════════════════════════════════════

-- Lua
lspconfig.lua_ls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }  -- 'vim' global'ini tanı
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    }
  }
})

-- Nix
lspconfig.nixd.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    nixd = {
      formatting = {
        command = { "nixpkgs-fmt" },
      },
    },
  },
})
-- Python
lspconfig.pyright.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

-- TypeScript/JavaScript
lspconfig.ts_ls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

-- Rust
lspconfig.rust_analyzer.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    ['rust-analyzer'] = {
      checkOnSave = {
        command = 'clippy'
      },
    }
  }
})

-- Go
lspconfig.gopls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

-- ═══════════════════════════════════════════════════════════
-- 🎨 DIAGNOSTIC GÖRÜNÜMÜ
-- ═══════════════════════════════════════════════════════════

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = 'always',
  },
})

-- Diagnostic işaretleri
local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
