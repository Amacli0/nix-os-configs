{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      ripgrep
      fd

      nixfmt-rfc-style
      black
      stylua
      terraform
    ];

    globals.mapleader = " ";

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
      completeopt = "menu,menuone,noselect";
    };

    colorschemes.gruvbox = {
      enable = true;
      settings.palette = "dark";
    };

    plugins = {

      nvim-tree.enable = true;

      gitsigns.enable = true;

      lualine = {
        enable = true;
        settings = {
          options.theme = "gruvbox";
        };
      };

      telescope = {
        enable = true;
        extensions = {
          fzf-native.enable = true;
        };
      };

      lsp = {
        enable = true;
        servers = {
          pyright.enable = true;
          clangd.enable = true;
          nixd.enable = true;
          bashls.enable = true;
          lua_ls.enable = true;
          terraformls.enable = true;
        };
      };

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

      conform-nvim = {
        enable = true;
        settings = {
          format_on_save = {
            timeout_ms = 500;
            lsp_fallback = true;
          };
          formatters_by_ft = {
            terraform = [ "terraform_fmt" ];
            python = [ "black" ];
            nix = [ "alejandra" ];
            lua = [ "stylua" ];
          };
          formatters = {
            nixfmt = {
              command = "${pkgs.nixfmt-rfc-style}/bin/alejandra";
            };
            black = {
              command = "${pkgs.black}/bin/black";
            };
            stylua = {
              command = "${pkgs.stylua}/bin/stylua";
            };
            terraform_fmt = {
              command = "${pkgs.terraform}/bin/terraform";
              args = [
                "fmt"
                "-"
              ];
            };
          };
        };
      };

      hop = {
        enable = true;
        settings.keys = "etovxqpdygfblzhckisuran";
      };

      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-p>" = "cmp.mapping.select_prev_item()";
            "<C-n>" = "cmp.mapping.select_next_item()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          };
          sources = [
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            { name = "buffer"; }
            { name = "path"; }
          ];
        };
      };

      luasnip.enable = true;

      neorg = {
        enable = true;
        settings = {
          load = {
            "core.defaults" = {
              __empty = null;
            };
            "core.concealer" = {
              __empty = null;
            };
            "core.dirman" = {
              config = {
                workspaces = {
                  notes = "~/notes";
                };
                default_workspace = "notes";
              };
            };
          };
        };
      };

      zen-mode = {
        enable = true;
      };

      treesitter = {
        enable = true;
        nixGrammars = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };
    };

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
      {
        mode = "n";
        key = "<leader>fm";
        action = "<cmd>lua require('conform').format()<cr>";
        options.desc = "Dosyayı Formatla";
      }
      {
        mode = "n";
        key = "<leader>gn";
        action = "<cmd>Gitsigns next_hunk<cr>";
        options.desc = "Sonraki Git Değişikliği";
      }
      {
        mode = "n";
        key = "<leader>gp";
        action = "<cmd>Gitsigns prev_hunk<cr>";
        options.desc = "Önceki Git Değişikliği";
      }
      {
        mode = "n";
        key = "<leader>zz";
        action = "<cmd>ZenMode<cr>";
        options.desc = "Odak Modu";
      }
      {
        mode = "n";
        key = "<leader>w";
        action = "<cmd>HopWord<cr>";
        options.desc = "Hop: Kelimeye atla";
      }
    ];
  };
}
