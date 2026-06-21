# home/quisiou/programs.nix

{ config, pkgs, lib, ... }:

{
    programs.firefox.enable = true;     # Web browser
    programs.git = {
        enable = true;
        settings = {
            user = {
                name = "QuiSioU";
                email = "marco.casteleiro@gmail.com";
            };
        };
    };
    programs.vesktop = {
        enable = true;
        vencord.settings = {
            autoUpdate = true;
            autoUpdateNotification = true;
            notifyAboutUpdates = true;
        };
    };
}
