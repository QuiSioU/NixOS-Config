# home/quisiou/xdg.nix


{ config, pkgs, lib, ... }:

{
    xdg = {
        desktopEntries = {
            btop.settings = {
                exec = "kitty -e btop";
            };
        };
    };
}
