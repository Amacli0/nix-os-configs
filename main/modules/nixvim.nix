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
      swapfile = false;
      backup = false;
      undofile = true;
      hlsearch = false;
      incsearch = true;
      termguicolors = true;
      scrolloff = 8;
      signcolumn = "yes";
      updatetime = 50;
      colorcolumn = "80";
      clipboard = "unnamedplus";
    };

    # Renk şeması
    colorschemes.gruvbox = {
      enable = true;
      settings = {
        palette = "dark";
        transparent_mode = false;
        bold = true;
        italic = {
          strings = true;
          emphasis = true;
          comments = true;
        };
      };
    };

    plugins = {
      # Web devicons (uyarıyı önlemek için)
      web-devicons.enable = true;

      # Dosya gezgini
      nvim-tree = {
        enable = true;
        openOnSetup = false;
        autoReloadOnWrite = true;
        filters = {
          dotfiles = false;
          exclude = [".git" "node_modules" ".cache"];
        };
        renderer = {
          highlightGit = true;
          icons.glyphs = {
            git = {
              unstaged = "✗";
              staged = "✓";
              unmerged = "";
              renamed = "➜";
              untracked = "★";
              deleted = "";
              ignored = "◌";
            };
          };
        };
      };

      # Git entegrasyonu
      gitsigns = {
        enable = true;
        settings = {
          signs = {
            add.text = "│";
            change.text = "│";
            delete.text = "_";
            topdelete.text = "‾";
            changedelete.text = "~";
            untracked.text = "┆";
          };
          current_line_blame = true;
        };
      };

      # Durum çubuğu
      lualine = {
        enable = true;
        settings = {
          options = {
            theme = "gruvbox";
            component_separators = {
              left = "|";
              right = "|";
            };
            section_separators = {
              left = "";
              right = "";
            };
          };
          sections = {
            lualine_a = ["mode"];
            lualine_b = ["branch" "diff" "diagnostics"];
            lualine_c = ["filename"];
            lualine_x = ["encoding" "fileformat" "filetype"];
            lualine_y = ["progress"];
            lualine_z = ["location"];
          };
        };
      };

      # Buffer satırı
      bufferline = {
        enable = true;
        settings.options = {
          mode = "buffers";
          separator_style = "slant";
          always_show_bufferline = true;
          show_buffer_close_icons = true;
          diagnostics = "nvim_lsp";
        };
      };

      # Fuzzy finder
      telescope = {
        enable = true;
        extensions = {
          fzf-native.enable = true;
          ui-select.enable = true;
        };
        settings = {
          defaults = {
            file_ignore_patterns = [
              "^.git/"
              "^.mypy_cache/"
              "^__pycache__/"
              "^output/"
              "^data/"
              "%.ipynb"
            ];
            layout_config.prompt_position = "top";
            sorting_strategy = "ascending";
          };
        };
      };

      # Treesitter (syntax highlighting)
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
          ensure_installed = [
            "bash"
            "c"
            "lua"
            "python"
            "nix"
            "markdown"
            "markdown_inline"
            "vim"
            "vimdoc"
          ];
        };
      };

      # LSP
      lsp = {
        enable = true;
        servers = {
          # Postgres LSP'yi açıkça devre dışı bırak (paket mevcut değil)
          postgres_lsp.enable = false;
          # Python
          pyright = {
            enable = true;
            settings = {
              python.analysis = {
                autoSearchPaths = true;
                diagnosticMode = "workspace";
                useLibraryCodeForTypes = true;
              };
            };
          };

          # C/C++
          clangd = {
            enable = true;
            cmd = ["clangd" "--background-index"];
          };

          # Nix
          nixd = {
            enable = true;
            settings = {
              nixpkgs.expr = "import <nixpkgs> { }";
              formatting.command = ["alejandra"];
            };
          };

          # Markdown
          marksman.enable = true;

          # Bash
          bashls.enable = true;

          # Lua
          lua_ls = {
            enable = true;
            settings.telemetry.enable = false;
          };
        };
      };

      # LSP UI iyileştirmeleri
      lsp-format.enable = true;
      lsp-lines.enable = true;

      # Tamamlama
      cmp = {
        enable = true;
        settings = {
          snippet.expand = ''
            function(args)
              require('luasnip').lsp_expand(args.body)
            end
          '';
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.abort()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = "cmp.mapping.select_next_item()";
            "<S-Tab>" = "cmp.mapping.select_prev_item()";
          };
          sources = [
            {name = "nvim_lsp";}
            {name = "luasnip";}
            {name = "buffer";}
            {name = "path";}
          ];
          window = {
            completion = {
              border = "rounded";
              winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None";
            };
            documentation = {
              border = "rounded";
            };
          };
        };
      };

      # Snippet motoru
      luasnip = {
        enable = true;
        settings = {
          enable_autosnippets = true;
          store_selection_keys = "<Tab>";
        };
      };

      # Yorum satırı toggle
      comment.enable = true;

      # Auto pairs
      nvim-autopairs.enable = true;

      # Indent guides
      indent-blankline = {
        enable = true;
        settings = {
          scope.enabled = true;
          exclude = {
            filetypes = ["help" "dashboard" "NvimTree"];
          };
        };
      };

      # Which-key (klavye kısayollarını göster)
      which-key = {
        enable = true;
        settings = {
          delay = 500;
          icons.group = "+";
        };
      };

      # Markdown önizleme
      markdown-preview = {
        enable = true;
        settings = {
          browser = "firefox";
          auto_start = 0; # 0 veya 1 kullan (boolean yerine)
          auto_close = 1;
        };
      };

      # Todo yorumlarını vurgula
      todo-comments = {
        enable = true;
        settings = {
          signs = true;
          keywords = {
            FIX = {
              icon = " ";
              color = "error";
            };
            TODO = {
              icon = " ";
              color = "info";
            };
            HACK = {
              icon = " ";
              color = "warning";
            };
            WARN = {
              icon = " ";
              color = "warning";
            };
            PERF = {
              icon = " ";
              color = "default";
            };
            NOTE = {
              icon = " ";
              color = "hint";
            };
          };
        };
      };
    };

    # Manuel eklentiler
    extraPlugins = with pkgs.vimPlugins; [
      zk-nvim
      vim-markdown
    ];

    # Lua yapılandırması
    extraConfigLua = ''
      -- zk.nvim kurulumu
      require("zk").setup({
        picker = "telescope",
      })

      -- vim-markdown ayarları
      vim.g.vim_markdown_folding_disabled = 1
      vim.g.vim_markdown_conceal = 2
      vim.g.vim_markdown_conceal_code_blocks = 0
      vim.g.vim_markdown_frontmatter = 1

      -- Diagnostics ayarları
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

      -- LSP on_attach
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        end,
      })
    '';

    # Klavye kısayolları
    keymaps = [
      # Genel
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>NvimTreeToggle<cr>";
        options.desc = "Dosya gezginini aç/kapat";
      }
      {
        mode = "n";
        key = "<leader>w";
        action = "<cmd>w<cr>";
        options.desc = "Dosyayı kaydet";
      }
      {
        mode = "n";
        key = "<leader>q";
        action = "<cmd>q<cr>";
        options.desc = "Çık";
      }

      # Buffer yönetimi
      {
        mode = "n";
        key = "<S-h>";
        action = "<cmd>bprevious<cr>";
        options.desc = "Önceki buffer";
      }
      {
        mode = "n";
        key = "<S-l>";
        action = "<cmd>bnext<cr>";
        options.desc = "Sonraki buffer";
      }
      {
        mode = "n";
        key = "<leader>bd";
        action = "<cmd>bdelete<cr>";
        options.desc = "Buffer'ı kapat";
      }

      # Telescope
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
        key = "<leader>fb";
        action = "<cmd>Telescope buffers<cr>";
        options.desc = "Buffer'larda ara";
      }
      {
        mode = "n";
        key = "<leader>fh";
        action = "<cmd>Telescope help_tags<cr>";
        options.desc = "Yardım ara";
      }

      # Git
      {
        mode = "n";
        key = "<leader>gg";
        action = "<cmd>Telescope git_status<cr>";
        options.desc = "Git durumu";
      }

      # Markdown
      {
        mode = "n";
        key = "<leader>mp";
        action = "<cmd>MarkdownPreviewToggle<cr>";
        options.desc = "Markdown önizleme";
      }

      # Zk (Zettelkasten)
      {
        mode = "n";
        key = "<leader>zn";
        action = "<cmd>ZkNew { title = vim.fn.input('Başlık: ') }<cr>";
        options.desc = "Yeni not";
      }
      {
        mode = "n";
        key = "<leader>zf";
        action = "<cmd>ZkNotes<cr>";
        options.desc = "Notları ara";
      }
      {
        mode = "n";
        key = "<leader>zt";
        action = "<cmd>ZkTags<cr>";
        options.desc = "Tag'lere göre ara";
      }
      {
        mode = "n";
        key = "<leader>zl";
        action = "<cmd>ZkLinks<cr>";
        options.desc = "Linkleri göster";
      }

      # LSP
      {
        mode = "n";
        key = "<leader>lf";
        action = "<cmd>lua vim.lsp.buf.format()<cr>";
        options.desc = "Kodu formatla";
      }
    ];
  };
}
