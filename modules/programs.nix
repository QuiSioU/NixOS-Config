# modules/programs.nix

{ config, pkgs, lib, ... }:

{
    programs.hyprland = {           		# Default window manager
        enable = true;
        xwayland.enable = true;
    };
    programs.neovim.enable = true;      	# Texterminal text editor
    programs.bash.completion.enable = true;	# Self-explanatory, innit?
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
