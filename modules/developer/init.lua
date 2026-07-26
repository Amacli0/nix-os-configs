-- ~/.config/nvim/init.lua (managed by NixOS, see modules/developer/neovim.nix)

vim.g.mapleader = " "

-------------------------------------------------
-- OPTIONS
-------------------------------------------------
local opt = vim.opt
opt.number = true
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.smartindent = true
opt.wrap = false
opt.clipboard = "unnamedplus"
opt.termguicolors = true
opt.completeopt = "menu,menuone,noselect"

-------------------------------------------------
-- SIMPLE PLUGINS
-------------------------------------------------
require("Comment").setup()
require("nvim-web-devicons").setup()
require("gitsigns").setup()
require("nvim-tree").setup()

require("ibl").setup({
  indent = { char = "│" },
  scope = { enabled = true, show_start = true, show_end = true },
})

require("lualine").setup({
  options = { theme = "gruvbox" },
})

require("nvim-treesitter.configs").setup({
  highlight = { enable = true },
})

require("telescope").setup()

-------------------------------------------------
-- FORMATTING (conform.nvim)
-------------------------------------------------
require("conform").setup({
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
  formatters_by_ft = {
    go = { "goimports" },
    python = { "black" },
    terraform = { "terraform_fmt" },
    nix = { "alejandra" },
  },
})

-------------------------------------------------
-- COMPLETION (nvim-cmp + luasnip)
-------------------------------------------------
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "path" },
    { name = "buffer" },
  }),
})

-------------------------------------------------
-- LSP
-------------------------------------------------
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local lspconfig = require("lspconfig")

for _, server in ipairs({
  "pyright",
  "terraformls",
  "gopls",
  "bashls",
  "nixd",
  "lua_ls",
}) do
  lspconfig[server].setup({ capabilities = capabilities })
end

-------------------------------------------------
-- KEYMAPS
-------------------------------------------------
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", "<leader>w", "<cmd>write<cr>", vim.tbl_extend("force", opts, { desc = "Save File" }))
map("n", "<leader>gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to Definition" }))
map("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover" }))
map("n", "<leader>e", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Diagnostics" }))
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", vim.tbl_extend("force", opts, { desc = "Telescope Find Files" }))
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", vim.tbl_extend("force", opts, { desc = "Telescope Find Text" }))
map("n", "<leader>gn", "<cmd>Gitsigns next_hunk<cr>", vim.tbl_extend("force", opts, { desc = "Git Next Hunk" }))
map("n", "<leader>gp", "<cmd>Gitsigns prev_hunk<cr>", vim.tbl_extend("force", opts, { desc = "Git Previous Hunk" }))
map("n", "<leader>nn", "<cmd>NvimTreeToggle<cr>", vim.tbl_extend("force", opts, { desc = "Toggle File Tree" }))
map("n", "<leader>fm", function()
  require("conform").format()
end, vim.tbl_extend("force", opts, { desc = "Format Code" }))
