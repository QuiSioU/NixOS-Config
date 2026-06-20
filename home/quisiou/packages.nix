# home/quisiou/packages.nix


{ config, pkgs, lib, ... }:

{
    home.packages = with pkgs; [
        # Basic terminal utilities
        bat duf dust ffmpeg jq poppler fd ripgrep fzf zoxide resvg imagemagick
        _7zz-rar

        # Text editors
        vscodium neovim

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

        # Language support and LSP
        clang-tools
        (runCommand "qmlls" { } ''
            mkdir -p $out/bin
            ln -s ${qt6.qtdeclarative}/bin/qmlls $out/bin/qmlls
        '')
        texlive.combined.scheme-medium

        # Desktop GUI
        awww eww quickshell

        # Other stuff
        bitwarden-desktop
        mpv
        imv
    ];
}
