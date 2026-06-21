# home/quisiou/theme.nix


{ config, pkgs, lib, ... }:

{
    gtk = {
        enable = true;
        iconTheme = {
            name = "Papirus-Dark";
            package = pkgs.papirus-icon-theme;
        };
        cursorTheme = {
            name = "Adwaita";
            package = pkgs.adwaita-icon-theme;
        };
    };

    qt = {
        enable = true;
        platformTheme.name = "gtk3";
    };
}
