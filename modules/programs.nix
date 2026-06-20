# modules/programs.nix

{ config, pkgs, lib, ... }:

{
    programs.gpu-screen-recorder.enable = true; # Self-explanatory, innit?
    programs.hyprland = {           		    # Default window manager
        enable = true;
        xwayland.enable = true;
    };
    programs.steam = {                  	    # Gaming platform
        enable = true;
        remotePlay.openFirewall = true;
        gamescopeSession.enable = true; 	    # better gaming performance
    };
    programs.bash = {
        completion.enable = true;
        shellAliases = {
            nrs = "sudo nixos-rebuild switch    --flake /home/quisiou/NixOS-Config#chirimbolo";
            nrb = "sudo nixos-rebuild dry-build --flake /home/quisiou/NixOS-Config#chirimbolo";
        };
    };
}
