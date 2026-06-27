# home/quisiou/xdg-desktop.nix


{ config, pkgs, lib, ... }:

{
    xdg.desktopEntries = {
        btop = {
            type = "Application";
            name = "btop++";
            genericName = "System Monitor";
            comment = "Resource monitor that shows usage and stats for processor, memory, disks, network and processes";
            icon = "btop"
            exec = "kitty -e btop";
            terminal = true;
            categories = "System;Monitor;ConsoleOnly";
            settings = {
                Version = 1.0;
                Keywords = "system;process;task";
            };
        };
    };
}
