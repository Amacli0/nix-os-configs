-- ═══════════════════════════════════════════════════════════
-- 🔭 TELESCOPE (Fuzzy Finder)
-- ═══════════════════════════════════════════════════════════

local telescope = require('telescope')
local actions = require('telescope.actions')

telescope.setup({
  defaults = {
    mappings = {
      i = {  -- Insert mode
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
        ['<Esc>'] = actions.close,
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = 'smart_case',
    }
  }
})

-- FZF native extension'ı yükle (daha hızlı arama)
telescope.load_extension('fzf')

-- ═══════════════════════════════════════════════════════════
-- ⌨️  TUŞ KISAYOLLARI
-- ═══════════════════════════════════════════════════════════

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find Files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live Grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help Tags' })
vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = 'Recent Files' })
vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = 'Find Word' })
