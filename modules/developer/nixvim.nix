################################
#         NIXVIM               #
################################
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  programs.nano.enable = false;
  programs.nixvim = {
    defaultEditor = true;

    enable = true;

    extraPackages = with pkgs; [
      ripgrep
      fd

      go
      gopls
      gotools

      black

      alejandra

      nixfmt-rfc-style

      gcc
      pkg-config
    ];
    globals.mapleader = " ";
    opts = {
      number = true;
      expandtab = true;
      tabstop = 2;
      shiftwidth = 2;
      smartindent = true;
      wrap = false;
      clipboard = "unnamedplus";
      termguicolors = true;
      completeopt = "menu,menuone,noselect";
    };

    plugins = {
      comment.enable = true;

      web-devicons.enable = true;

      gitsigns.enable = true;

      nvim-tree.enable = true;

      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          ensure_installed = [
            "nix"
            "lua"
            "python"
            "go"
            "bash"
            "terraform"
            "json"
            "yaml"
          ];
        };
      };
      indent-blankline = {
        enable = true;
        settings = {
          indent = {
            char = "│";
          };
          scope = {
            enabled = true;
            show_start = true;
            show_end = true;
          };
        };
      };

      lualine = {
        enable = true;
        settings = {
          options.theme = "gruvbox";
        };
      };

      lsp = {
        enable = true;
        servers = {
          pyright.enable = true;
          terraformls.enable = true;
          gopls.enable = true;
          bashls.enable = true;
          nixd.enable = true;
          lua_ls.enable = true;
        };
      };
      telescope = {
        enable = true;
      };

      conform-nvim = {
        enable = true;
        settings = {
          format_on_save = {
            timeout_ms = 500;
            lsp_fallback = true;
          };
          formatters_by_ft = {
            go = ["goimports"];
            python = ["black"];
            terraform = ["terraform_fmt"];
            nix = ["alejandra"];
          };
        };
      };

      luasnip.enable = true;
      cmp = {
        enable = true;
        autoEnableSources = true;

        settings = {
          snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";

          mapping = {
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.close()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          };

          sources = [
            {name = "nvim_lsp";}
            {name = "luasnip";}
            {name = "path";}
            {name = "buffer";}
          ];
        };
      };
    };

    ##########
    #key maps#
    ##########
    keymaps = [
      {
        mode = "n";
        key = "<leader>w";
        action = "<cmd>write<cr>";
        options.desc = "Save File";
      }
      {
        mode = "n";
        key = "<leader>gd";
        action = "<cmd>lua vim.lsp.buf.definition()<cr>";
        options.desc = "Go to Definition";
      }
      {
        mode = "n";
        key = "K";
        action = "<cmd>lua vim.lsp.buf.hover()<cr>";
        options.desc = "Hover";
      }
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>lua vim.diagnostic.open_float()<cr>";
        options.desc = "Diagnostics";
      }
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>Telescope find_files<cr>";
        options.desc = "Telescope Find Files";
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>Telescope live_grep<cr>";
        options.desc = "Telescope Find Text";
      }
      {
        mode = "n";
        key = "<leader>gn";
        action = "<cmd>Gitsigns next_hunk<cr>";
        options.desc = "Git Next Hunk";
      }
      {
        mode = "n";
        key = "<leader>gp";
        action = "<cmd>Gitsigns prev_hunk<cr>";
        options.desc = "Git Previous Hunk";
      }
      {
        mode = "n";
        key = "<leader>nn";
        action = "<cmd>NvimTreeToggle<cr>";
        options.desc = "Toggle File Tree";
      }
      {
        mode = "n";
        key = "<leader>fm";
        action = "<cmd>lua require('conform').format()<cr>";
        options.desc = "Format Code";
      }
    ];
  };
}
