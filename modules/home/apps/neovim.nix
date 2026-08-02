################################
#         NEOVIM                #
################################
{
  config,
  pkgs,
  lib,
  ...
}: let
  # GitHub'daki tidalcycles/vim-tidal reposunu özel bir Vim eklentisi olarak paketliyoruz:
  vim-tidal-src = pkgs.vimUtils.buildVimPlugin {
    pname = "vim-tidal";
    version = "2024-latest";
    src = pkgs.fetchFromGitHub {
      owner = "tidalcycles";
      repo = "vim-tidal";
      rev = "master"; # İsterseniz belirli bir commit hash de yazabilirsiniz
      hash = "sha256-8gyk17YLeKpLpz3LRtxiwbpsIbZka9bb63nK5/9IUoA="; # İlk çalıştırmada Nix doğru hash'i verecek
    };
  };
in {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = false;
    withRuby = false;

    # Plugins (replaces nixvim's `plugins.*.enable`)
    plugins = with pkgs.vimPlugins; [
      comment-nvim
      nvim-web-devicons
      gitsigns-nvim
      nvim-tree-lua

      vim-tidal-src

      nvim-treesitter.withAllGrammars

      indent-blankline-nvim
      lualine-nvim

      # LSP
      nvim-lspconfig

      # Telescope
      telescope-nvim
      plenary-nvim

      # Formatting
      conform-nvim

      # Snippets + completion
      luasnip
      nvim-cmp
      cmp-nvim-lsp
      cmp-path
      cmp-buffer
      cmp_luasnip
    ];

    extraPackages = with pkgs; [
      ripgrep
      fd

      go
      gopls
      gotools

      terraform-ls
      bash-language-server
      nixd
      lua-language-server

      black
      alejandra
      nixfmt
    ];

    initLua = builtins.readFile ./nvim/init.lua;
  };
}
