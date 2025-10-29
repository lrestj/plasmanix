{ config, pkgs, lib, pkgsStable, ... }:

{

  nixpkgs.overlays = [
      (final: prev: {
          sway = prev.sway.overrideAttrs (old: {
              name = "sway-git";
              src = prev.fetchFromGitHub {
                  owner = "swaywm";
                  repo = "sway";
                  rev = "latest";
                  hash = "";
              };
          });  
      })
  ];

}
