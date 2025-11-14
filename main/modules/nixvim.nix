{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    # Leader tuşu
    globals.mapleader = " ";

    # Temel ayarlar
    opts = {
      number = true;
      relativenumber = true;
      expandtab = true;
      tabstop = 2;
      shiftwidth = 2;
      smartindent = true;
      wrap = false;
      clipboard = "unnamedplus";
      termguicolors = true;
    };

    # Renk şeması
    colorschemes.gruvbox = {
      enable = true;
      settings.palette = "dark";
    };

    plugins = {
      # Dosya gezgini
      nvim-tree.enable = true;

      # Git işaretleri
      gitsigns.enable = true;

      # Durum çubuğu
      lualine = {
        enable = true;
        settings = {
          options.theme = "gruvbox";
        };
      };

      # Fuzzy finder
      telescope.enable = true;

      # LSP
      lsp = {
        enable = true;
        servers = {
          # Postgres'i açıkça kapat
          postgres_lsp.enable = false;
          
          # Temel serverlar
          pyright.enable = true;
          clangd.enable = true;
          nixd.enable = true;
          bashls.enable = true;
          lua_ls.enable = true;
        };
      };

      # Fonksiyon imzası önizlemesi (yazarken parametreleri gösterir)
      lsp-signature = {
        enable = true;
        settings = {
          bind = true;
          handler_opts = {
            border = "rounded";
          };
          hint_enable = true;
          hint_prefix = "🔍 ";
        };
      };

      # Otomatik tamamlama
      cmp = {
        enable = true;
        autoEnableSources = true;
      };

      # Syntax highlighting
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };
    };

    # Temel kısayollar
    keymaps = [
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>NvimTreeToggle<cr>";
        options.desc = "Dosya ağacı";
      }
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>Telescope find_files<cr>";
        options.desc = "Dosya ara";
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>Telescope live_grep<cr>";
        options.desc = "Metin ara";
      }
    ];
  };
}
