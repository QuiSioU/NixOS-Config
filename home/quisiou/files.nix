# home/quisiou/files.nix

{ config, pkgs, lib, ... }:

{
    home.file = {
        # Quickshell
        "Dotfiles/quickshell/shell/quickapps.json".text = ''
            [
                "codium",
                "firefox",
                "vesktop",
                "steam",
                "gimp",
                "org.inkscape.Inkscape",
                "spotify",
                "org.musescore.MuseScore"
            ]
        '';
    };
}
