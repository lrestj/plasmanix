{ config, pkgs, inputs, pkgsStable, ... }:

{

  imports = [ 
      # ./vimoverlay.nix
        ./greetd.nix
  ]; 
  
  fonts.packages = with pkgs; [
      font-awesome
      corefonts vista-fonts
      noto-fonts
      nerd-fonts.commit-mono
      nerd-fonts.hack
      jetbrains-mono
      nerd-fonts.symbols-only
  ];
  
  _module.args.pkgsStable = import inputs.nixpkgs-stable {
      inherit (pkgs.stdenv.hostPlatform) system;
      inherit (config.nixpkgs) config;
    };
  
    environment.systemPackages =
        (with pkgs; [
            audacity
            banana-cursor
            bibata-cursors
            brave
            btop
            fastfetch
            fish
            greetd tuigreet
            kdePackages.kcalc
            kitty
            pcmanfm-qt
            pdfarranger
            rclone
            reaper  
            reaper-reapack-extension
            reaper-sws-extension
            simple-scan
            vim-full
            xnviewmp
            xorg.xeyes
            xournalpp
            yazi
            ytdownloader
            zip
            p7zip
            (pkgs.writeScriptBin "sct" ''
                #!/bin/sh
                killall wlsunset &> /dev/null;
                if [ $# -eq 1 ]; then
                    temphigh=$(( $1 + 1 ))
                    templow=$1
                    wlsunset -t $templow -T $temphigh &> /dev/null &
                else
                    killall wlsunset &> /dev/null;
                fi
            '')
            ])

        ++

        (with pkgsStable; [
            # vim-full
        ]);
  
  programs = {
      git = {
          enable = true;
          config = {
              safe.directory = "/home/libor/.dotfiles";
              init = {
                  defaultBranch = "main";
                  userName  = "libor";
                  userEmail = "rest@seznam.cz";
              };
          };
      };
  };

}

#####  END OF FILE  #####
