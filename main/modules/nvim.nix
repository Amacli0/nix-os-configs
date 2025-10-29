{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    
    # ✅ TÜM LUA DOSYALARINI YÜKLE
    extraLuaConfig = ''
      -- Options
      ${builtins.readFile ./nvim/options.lua}
      
      -- Plugin Configurations
      ${builtins.readFile ./nvim/plugin/lsp.lua}
      ${builtins.readFile ./nvim/plugin/cmp.lua}
      ${builtins.readFile ./nvim/plugin/treesitter.lua}
      ${builtins.readFile ./nvim/plugin/telescope.lua}
      ${builtins.readFile ./nvim/plugin/other.lua}
    '';
    
    plugins = with pkgs.vimPlugins; [
      # 🎨 Tema ve Görünüm
      catppuccin-nvim
      lualine-nvim
      nvim-web-devicons
      
      # 📂 Dosya Yönetimi
      telescope-nvim
      telescope-fzf-native-nvim
      plenary-nvim
      
      # 🌳 Treesitter
      (nvim-treesitter.withPlugins (p: [
        p.nix p.lua p.python p.javascript
        p.typescript p.rust p.go p.html
        p.css p.json p.yaml p.markdown
        p.bash
      ]))
      nvim-treesitter-textobjects
      
      # 💡 LSP
      nvim-lspconfig
      fidget-nvim
      
      # 📝 Auto-completion
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      luasnip
      cmp_luasnip
      friendly-snippets
      
      # 🔧 Yardımcı Plugin'ler
      comment-nvim
      vim-sleuth
      gitsigns-nvim
      which-key-nvim
      indent-blankline-nvim
      
      # 🚀 Performans
      impatient-nvim
    ];
    
    extraPackages = with pkgs; [
      # Language Servers
      lua-language-server
      nixd                      # ✅ nixd kullan
      pyright
      nodePackages.typescript-language-server
      rust-analyzer
      gopls
      
      # Formatters & Linters
      stylua
      nixpkgs-fmt
      black
      isort
      nodePackages.prettier
      
      # Diğer araçlar
      ripgrep
      fd
    ];
  };
}
