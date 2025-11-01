{ pkgs,inputs, ...}:

  let
    tuigreet = "${pkgs.tuigreet}/bin/tuigreet";
  in
 
{

  services.greetd = {
      enable = true;
      settings = {
          initial_session = {
              command = "startplasma-wayland";
              user = "libor";
          };
          default_session = {
              command = "${tuigreet} --greeting 'Vítejte v NixOS!' --asterisks --time --time-format %c --remember --remember-session --sessions startplasma-wayland";
              user = "greeter";
          };
      };
  };

  systemd.services.greetd.serviceConfig = {
      Type = "idle";
      StandardInput = "tty";
      StandardOutput = "tty";
      StandardError = "journal";
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
  };

}
