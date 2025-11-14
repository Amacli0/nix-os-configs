{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  # 1. Genel NixVim Ayarları
  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    # Gruvbox renk şemasının konfigürasyonu
    colorschemes.gruvbox = {
      enable = true;
      settings.palette = "dark";
    };

    extraConfig = "colorscheme gruvbox";

    # 2. Tüm Eklentilerin Tanımlandığı Kısım (plugins)
    plugins = {
      # Temel Eklentiler
      nvim-tree.enable = true;
      gitsigns.enable = true;

      # Durum Çubuğu (Status Line)
      lualine = {
        enable = true;
        sections.lualine_a = ["mode"];
        sections.lualine_c = ["filename"];
      };

      # LSP ve Tamamlama (Autocompletion)
      lsp = {
        enable = true;
        servers = {
          pyright.enable = true;
          clangd.enable = true;
          nixd.enable = true;
          markdownlint.enable = true; # Markdown linter
          bashls.enable = true;
        };
      };
      cmp = {
        enable = true;
        settings = {
          sources = [
            {name = "nvim_lsp";}
            {name = "buffer";}
          ];
        };
        snippet.enable = true;
      };

      # 3. Not Alma Eklentileri (DOĞRU YERLEŞİM!)

      # Zettelkasten Not Sistemi (nvim-zk)
      zk = {
        enable = true;
        # Tilde (~) işaretini kullanmak Home Manager'da daha garanti sonuç verir,
        # ancak sistem modülünde de çalışması beklenir.
        workspace = "~/.notes/zk_vault";
        fileType = "markdown";
      };

      # Markdown Önizleme (nvim-markdown-preview ya da benzeri)
      # Not: NixVim'de bu eklenti genellikle `markdown-preview` adıyla tanımlanır.
      markdown-preview = {
        enable = true;
      };

      # Gelişmiş Markdown Syntax Desteği (vim-markdown)
      # Not: Bu eklenti de programs.nixvim.plugins altında olmalıdır.
      vim-markdown = {
        enable = true;
        settings.conceal_code_blocks = true;
      };
    };
  };
}
