################################
#         NEOVIM                #
################################
{
  config,
  pkgs,
  lib,
  ...
}: {
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
