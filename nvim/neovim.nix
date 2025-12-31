{ pkgs ? import <nixpkgs> {} }:

pkgs.neovim.override {
  configure = {
    customRC = ''
      luafile ~/.config/nvim/init.lua
    '';
    packages.myPlugins = with pkgs.vimPlugins; {
      start = [
        (nvim-treesitter.withPlugins (p: [
          p.lua
          p.python
          p.markdown
          p.markdown_inline  # required for code block injections
          p.javascript
          p.idris
          p.typescript
          p.haskell
        ]))
      ];
    };
  };
}
