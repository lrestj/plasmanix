{ config, pkgs, lib, pkgsStable, ... }:

{

  nixpkgs.overlays = [
      (final: prev: {
          vim-full = prev.vim-full.overrideAttrs (old: {
              name = "vim-full-git";
              src = prev.fetchFromGitHub {
                  owner = "vim";
                  repo = "vim";
                  rev = "latest";
                  hash = "";
              };
          });  
      })
  ];

}
