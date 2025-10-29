##### HP Zbook config #####

{ config, pkgs, lib, ... }:

{

  imports =
      [ # Include hardware-configuration.nix
        ./hardware-configuration.nix
        ../../modules/pkgs.nix
      ];

  documentation.man.generateCaches = false;
  nixpkgs.config.allowUnfree = true;
  environment = {
      localBinInPath = true;
      variables = {
          EDITOR = "vim";
      };
  };
  hardware = {
      cpu.intel.updateMicrocode = true;
      nvidia = {
          modesetting.enable = true;
          powerManagement.enable =true;
          nvidiaSettings = true;
          package = config.boot.kernelPackages.nvidiaPackages.stable;
          open = false;
          prime = {
              intelBusId = "PCI:0:2:0";
              nvidiaBusId = "PCI:1:0:0";
              offload = {
                  enable = true;
                  enableOffloadCmd = true;
              };
              # sync.enable = true;
          };
      };
      graphics = {
          enable = true;
          extraPackages = with pkgs; [
              intel-media-driver # For Broadwell (2014) or newer processors. LIBVA_DRIVER_NAME=iHD
              libvdpau-va-gl
          ];
      }; 
      sane = {
          enable = true; # enables support for SANE scanners
          extraBackends = [ pkgs.hplip ];
      };
  };
  
  nix = {
      settings = {
          experimental-features = [ "nix-command" "flakes" ];
          download-buffer-size = 125829120;
          substituters = [
              "https://hyprland.cachix.org"
              "https://yazi.cachix.org" 
          ];
          trusted-substituters = [
              # "https://hyprland.cachix.org"
              # "https://yazi.cachix.org"  
              "https://cache.nixos.org"
              "https://nixpkgs-wayland.cachix.org"
          ];
          trusted-public-keys = [
              # "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
              # "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
              "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
              "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
          ];
      };
      gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 14d";
      };
  };
  
  security = {
      rtkit.enable = true;
      polkit.enable = true;
  };

  systemd.sleep.extraConfig = ''
      AllowHibernation=no
      AllowHybridSleep=no
      AllowSuspendThenHibernate=no
  '';

  users.users.libor = {
      isNormalUser = true;
      description = "libor";
      extraGroups = [ "networkmanager" "wheel" "scanners" "lp" "input" ];
  };

  boot = {
      kernelPackages = pkgs.linuxPackages_latest;
      kernel.sysctl."vm.swappiness" = 10;
      initrd.kernelModules = [ "nvidia" "i915" "nvidia_modeset" "nvidia_drm" ];
      loader = {
          timeout = 2;
          systemd-boot = {
              enable = true;
              configurationLimit = 17;
              # extraEntries = {
              #     "Lmde.conf" = ''
              #         title Mint Debian Edition 7
              #         efi /EFI/debian/shimx64.efi
              #     '';
              # };
         };
          efi = {
              canTouchEfiVariables = true;
              efiSysMountPoint = "/boot";
          };
      };
  };

  networking = {
      hostName = "zbook";
      networkmanager.enable = true;
      firewall = {
          enable = true;
          #allowedTCPPorts = [ ... ];
          #allowedUDPPorts = [ ... ];
      };
  };

  # Locale settings
  console.useXkbConfig = true;
  time.timeZone = "Europe/Prague";
  i18n.defaultLocale = "cs_CZ.UTF-8";
  i18n.extraLocaleSettings = {
      LC_ADDRESS = "cs_CZ.UTF-8";
      LC_IDENTIFICATION = "cs_CZ.UTF-8";
      LC_MEASUREMENT = "cs_CZ.UTF-8";
      LC_MONETARY = "cs_CZ.UTF-8";
      LC_NAME = "cs_CZ.UTF-8";
      LC_NUMERIC = "cs_CZ.UTF-8";
      LC_PAPER = "cs_CZ.UTF-8";
      LC_TELEPHONE = "cs_CZ.UTF-8";
      LC_TIME = "cs_CZ.UTF-8";
  };

  services = {
      envfs.enable = true;
      displayManager = {
          sddm.enable = true;
          autoLogin = {
              enable = true;
              user = "libor";
          };
      };
      desktopManager.plasma6.enable = true;
      xserver = {
          xkb.layout = "cz";
          videoDrivers = [
             "modesetting"
             "nvidia"
          ];
      };
      journald.extraConfig = "SystemMaxUse=50M";
      getty.autologinUser = "libor";
      pipewire = {
          enable = true;
          alsa = {
              enable = true;
              support32Bit = true;
              };
          pulse.enable = true;
          jack.enable = true;
          extraConfig.jack = {
              "10-clock-rate" = {
                  "jack.properties" = {
                      "node.latency" = "256/48000";
                      "node.rate" = "1/48000";
                      "node.lock-quantum" = true;
                  };
              };
          };
      };

      # To add the printer run:
      # NIXPKGS_ALLOW_UNFREE=1 nix-shell -p hplipWithPlugin --run 'sudo -E hp-setup'
      printing = {
          enable = true;
          drivers = [ pkgs.hplip ];
      };
      avahi = {
          enable = true;
          nssmdns4 = true;
          openFirewall = true;
      };
      openssh = {
          enable = true;
          settings = {
              PermitRootLogin = "no";
              PasswordAuthentication = false;
          };
      };
  };

  # NFS Synology shares:
  fileSystems."/nfs/FilmyNas" = {
      device = "192.168.77.18:/volume1/Filmy";
      fsType = "nfs";
      options = [ "nfsvers=4" "x-systemd.automount" "noauto" "x-systemd.iddle-timeout=450" "nofail" ];
  };
  fileSystems."/nfs/Nas" = {
      device = "192.168.77.18:/volume1/Rodinas";
      fsType = "nfs";
      options = [ "nfsvers=4" "x-systemd.automount" "noauto" "x-systemd.iddle-timeout=450" "nofail" ];
  };
  fileSystems."/nfs/HudbaNas" = {
      device = "192.168.77.18:/volume1/Hudba";
      fsType = "nfs";
      options = [ "nfsvers=4" "x-systemd.automount" "noauto" "x-systemd.iddle-timeout=450" "nofail" ];
  };
  
  # Release version of the first install of this system
  system.stateVersion = "25.05";

}

#####  END OF FILE  #####
