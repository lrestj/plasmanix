{ config, pkgs, lib, ... }:

{

    services.flatpak = {
        enable = true;
        packages = [
            "org.vim.Vim"
        ];
        update.auto = {
            enable = true;
            onCalendar = "weekly";
        };
    };

}

#####  END OF FILE  #####
