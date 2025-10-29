{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;  # Varsayılan editör olarak ayarla
    viAlias = true;        # 'vi' komutu ile çalıştır
    vimAlias = true;       # 'vim' komutu ile çalıştır
    
    # Lua yapılandırmasını yükle
    extraLuaConfig = ''
      ${builtins.readFile ./nvim/options.lua}
    '';

    plugins = with pkgs.vimPlugins; [
      # 🎨 Tema ve Görünüm
      catppuccin-nvim           # Modern, şık tema
      lualine-nvim              # Durum çubuğu
      nvim-web-devicons         # İkonlar
      
      # 📂 Dosya Yönetimi
      telescope-nvim            # Fuzzy finder
      telescope-fzf-native-nvim # Telescope için native sorter
      plenary-nvim              # Lua fonksiyonları (telescope dependency)
      
      # 🌳 Treesitter (Syntax Highlighting)
      (nvim-treesitter.withPlugins (p: [
        p.nix p.lua p.python p.javascript
        p.typescript p.rust p.go p.html
        p.css p.json p.yaml p.markdown
        p.bash
      ]))
      nvim-treesitter-textobjects
      
      # 💡 LSP (Language Server Protocol)
      nvim-lspconfig            # LSP yapılandırma
      fidget-nvim               # LSP loading progress
      
      # 📝 Auto-completion
      nvim-cmp                  # Completion engine
      cmp-nvim-lsp              # LSP source
      cmp-buffer                # Buffer source
      cmp-path                  # Path source
      cmp-cmdline               # Command line source
      luasnip                   # Snippet engine
      cmp_luasnip               # Snippet source
      friendly-snippets         # Hazır snippet'ler
      
      # 🔧 Yardımcı Plugin'ler
      comment-nvim              # Kolay yorum satırı
      vim-sleuth                # Otomatik indent algılama
      gitsigns-nvim             # Git işaretleri
      which-key-nvim            # Tuş kombinasyonlarını göster
      indent-blankline-nvim     # Indent çizgileri
      
      # 🚀 Performans
      impatient-nvim            # Lua modüllerini cache'le
    ];

    # LSP sunucularını sistem paketlerine ekle
    extraPackages = with pkgs; [
      # Language Servers
      lua-language-server       # Lua
      nil                       # Nix (modern, nixd yerine)
      pyright                   # Python
      nodePackages.typescript-language-server  # TypeScript/JavaScript
      rust-analyzer             # Rust
      gopls                     # Go
      
      # Formatters & Linters
      stylua                    # Lua formatter
      nixpkgs-fmt               # Nix formatter
      black                     # Python formatter
      isort                     # Python import sorter
      nodePackages.prettier     # JS/TS/HTML/CSS formatter
      
      # Diğer araçlar
      ripgrep                   # Telescope için gerekli
      fd                        # Dosya arama
    ];
  };
}
