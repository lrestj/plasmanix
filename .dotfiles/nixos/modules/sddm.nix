{ config, pkgs, ... }:

  let
      custom-sddm-astronaut = pkgs.sddm-astronaut.override {
          embeddedTheme = "jake_the_dog";
      };
  in

{
  
  services.displayManager = {
      autoLogin = {
          enable = true;
          user = "libor";
      };
      sddm = {
          enable = true;
          wayland.enable = true;
          #package = pkgs.kdePackages.sddm;
          theme = "sddm-astronaut-theme";
          settings = {
              Theme = {
                  Current = "sddm-astronaut-theme";
                  CursorTheme = "Bibata-Modern-Classic";
                  CursorSize = "20";
              };
          };
    
          extraPackages = with pkgs; [
              custom-sddm-astronaut
          ];
      };
  };
  environment.systemPackages = with pkgs; [
      custom-sddm-astronaut
      kdePackages.qtmultimedia
  ];

}
