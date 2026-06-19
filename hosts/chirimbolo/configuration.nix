# hosts/chirimbolo/configuration.nix


# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
    imports = [
        # Include the results of the hardware scan.
        ./hardware-configuration.nix

    # Modules
    ../../modules/boot.nix
        ../../modules/video.nix
        ../../modules/networking.nix
        ../../modules/locale.nix
        ../../modules/audio.nix
        ../../modules/bluetooth.nix
        ../../modules/fonts.nix
        ../../modules/programs.nix
        ../../modules/services.nix
        ../../modules/users.nix
    ];


    # --- Add flakes support ---------------------------------------------
    nix.settings.experimental-features = [ "nix-command" "flakes" ];


    # --- Networking hostname --------------------------------------------
    networking.hostName = "chirimbolo";


    # --- Allow unfree packages ------------------------------------------
    nixpkgs.config.allowUnfree = true;


    # --- Security -------------------------------------------------------
    security.polkit.enable = true;


    # --- System state version -------------------------------------------
    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "26.05";


    # --- System packages ------------------------------------------------
    # Specific outdated package versions required by other packages
    nixpkgs.config.permittedInsecurePackages = [
        "electron-39.8.10"
    ];

    # To expose a single binary from a package without installing the whole thing,
    # use runCommand (for one binary) or linkFarm (for multiple):

    # (pkgs.runCommand "name" { } ''
    #     mkdir -p $out/bin
    #     ln -s ${pkgs.some-package}/bin/binary $out/bin/binary
    # '')

    # (pkgs.linkFarm "name" [
    #     { name = "bin/binary"; path = "${pkgs.some-package}/bin/binary"; }
    # ])

    environment.systemPackages = with pkgs; [
        # Basic utilities
        bash
        wget curl bat duf dust

        (python3.withPackages (ps: with ps; [
            jinja2
        ]))

        ffmpeg _7zz-rar jq poppler fd ripgrep fzf zoxide resvg imagemagick

        # Text editors
        vscodium

        # Terminal (and tools)
        kitty starship fastfetch

        # Terminal text editor
        (yazi.override {
            _7zz = _7zz-rar;  # Support for RAR extraction
        })

        # System monitors
        btop brightnessctl

        # Hyprland ecosystem
        hyprshot wl-clipboard cliphist

        # Language servers
        clang-tools
        (runCommand "qmlls" { } ''
            mkdir -p $out/bin
            ln -s ${qt6.qtdeclarative}/bin/qmlls $out/bin/qmlls
        '')

        # Desktop GUI
        awww eww quickshell

        # Other stuff
        bitwarden-desktop
        mpv
        imv
    ];
}
