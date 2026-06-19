# modules/programs.nix

{ config, pkgs, lib, ... }:

{
    programs.hyprland = {           		# Default window manager
        enable = true;
        xwayland.enable = true;
    };
    programs.neovim.enable = true;      	# Texterminal text editor
    programs.bash = {
        completion.enable = true;           # Self-explanatory, innit?
        shellAliases = {
            nrs = "sudo nixos-rebuild switch    --flake /home/quisiou/NixOS-Config#chirimbolo";
            nrb = "sudo nixos-rebuild dry-build --flake /home/quisiou/NixOS-Config#chirimbolo";
        };
    };
    programs.firefox.enable = true;     	# Web browser
    programs.steam = {                  	# Gaming platform
        enable = true;
        remotePlay.openFirewall = true;
        gamescopeSession.enable = true; 	# better gaming performance
    };
    programs.gpu-screen-recorder.enable = true;
    programs.git = {
        enable = true;
        config = {
            user = {
                name = "QuiSioU";
                email = "marco.casteleiro@gmail.com";
            };
        };
    };
}
