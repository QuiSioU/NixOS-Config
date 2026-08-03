# modules/programs.nix

{ config, pkgs, lib, inputs, ... }:

{
    imports = [
        ./proton.nix
        inputs.steam-config-nix.nixosModules.default
    ];

    programs.gpu-screen-recorder.enable = true; # Self-explanatory, innit?
    programs.hyprland = {           		    # Default window manager
        enable = true;
        xwayland.enable = true;
    };
    programs.steam = {                  	    # Gaming platform
        enable = true;
        remotePlay.openFirewall = true;
        gamescopeSession.enable = true; 	    # better gaming performance
        extraCompatPackages = with pkgs; [
            proton-ge-bin
            ge-proton9-24
            ge-proton10-28
        ];
        config = {
            enable = true;
            onSteamRunning = "close";
        };
    };
    programs.gamemode.enable = true;            # Gamemode for steam games
    programs.zsh.enable = true;
    programs.obs-studio = {
        enable = true;
        enableVirtualCamera = true;
    };
    programs.nix-ld = {                         # Run unpatched dynamic binaries on NixOS.
        enable = true;
        libraries = with pkgs; [
            stdenv.cc.cc.lib   # libstdc++ — needed by nearly everything (numpy, pandas, torch...)
            zlib
            openssl
            curl
            expat
            libGL
            glib
            icu
            fuse3
            nss
            xorg.libX11
            xorg.libXext
            xorg.libXrender
            fontconfig
            freetype
        ];
    };
}
