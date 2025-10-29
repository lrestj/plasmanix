{ config, pkgs, lib, pkgsStable, ... }:

{

  nixpkgs.overlays = [
      (final: prev: {
          vim-full = prev.vim-full.overrideAttrs (old: {
              name = "vim-full-git";
              src = prev.fetchFromGitHub {
                  owner = "vim";
                  repo = "vim";
                  rev = "6f020cde569073622cc085251e47d82323d5c4bd";
                  hash = "sha256-C0yQvZ1A6Moyr/FXzaJdaH/VJwtD2WI9opA1Y7U2aXc=";
              };
          });  
      })
  ];

}
