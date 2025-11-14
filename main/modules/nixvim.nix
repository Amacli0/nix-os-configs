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

    colorschemes.gruvbox = {
      enable = true;
      settings.palette = "dark";
    };

    plugins = {
      # Temel Eklentiler
      nvim-tree.enable = true;
      gitsigns.enable = true;

      # Durum Çubuğu
      lualine = {
        enable = true;
        settings = {
          sections = {
            lualine_a = ["mode"];
            lualine_c = ["filename"];
          };
        };
      };

      # LSP
      lsp = {
        enable = true;
        servers = {
          pyright.enable = true;
          clangd.enable = true;
          nixd.enable = true;
          marksman.enable = true; # Markdown LSP (markdownlint yerine)
          bashls.enable = true;
        };
      };

      # Tamamlama
      cmp = {
        enable = true;
        settings = {
          snippet.expand = ''
            function(args)
              require('luasnip').lsp_expand(args.body)
            end
          '';
          sources = [
            {name = "nvim_lsp";}
            {name = "luasnip";}
            {name = "buffer";}
            {name = "path";}
          ];
        };
      };

      luasnip.enable = true;

      # Markdown Önizleme
      markdown-preview = {
        enable = true;
        settings = {
          browser = "firefox"; # veya "chromium"
        };
      };

      # Telescope (zk için gerekli)
      telescope.enable = true;
    };

    # Manuel Eklentiler
    extraPlugins = with pkgs.vimPlugins; [
      zk-nvim
      vim-markdown
    ];

    # Lua Yapılandırması
    extraConfigLua = ''
      -- zk.nvim kurulumu
      require("zk").setup({
        picker = "telescope",
      })

      -- vim-markdown ayarları
      vim.g.vim_markdown_folding_disabled = 1
      vim.g.vim_markdown_conceal = 2
      vim.g.vim_markdown_conceal_code_blocks = 0
    '';

    # Notlar için kısayollar
    keymaps = [
      {
        mode = "n";
        key = "<leader>zn";
        action = "<cmd>ZkNew { title = vim.fn.input('Title: ') }<cr>";
        options.desc = "Yeni not oluştur";
      }
      {
        mode = "n";
        key = "<leader>zf";
        action = "<cmd>ZkNotes<cr>";
        options.desc = "Notları ara";
      }
    ];
  };
}
