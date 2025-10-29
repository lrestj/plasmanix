{ config, pkgs, lib, pkgsStable, ... }:

{

  nixpkgs.overlays = [
      (final: prev: {
          vim-full = prev.vim-full.overrideAttrs (old: {
              name = "vim-full-git";
              src = prev.fetchFromGitHub {
                  owner = "vim";
                  repo = "vim";
                  rev = "235e77a3a35525671d6a5e60c180c0dcc0351ea1";
                  hash = "sha256-nNWkfVlWbnqjt0npy2JPzJPcR0mrRRgU3zZ+UtL4aQo=";
              };
          });  
      })
  ];

}
