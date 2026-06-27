# home/quisiou/xdg-desktop.nix


{ config, pkgs, lib, ... }:

{
    xdg.desktopEntries = {
        btop = {
            type = "Application";
            name = "btop++";
            genericName = "System Monitor";
            comment = "Resource monitor that shows usage and stats for processor, memory, disks, network and processes";
            icon = "btop";
            exec = "kitty -e btop";
            terminal = true;
            categories = [
                "System"
                "Monitor"
                "ConsoleOnly"
            ];
            settings = {
                Keywords = "system;process;task";
            };
        };
        nvim = {
            type = "Application";
            name = "Neovim";
            genericName = "Text Editor";
            comment = "Edit text files";
            icon = "nvim";
            exec = "kitty -e nvim %F";
            terminal = true;
            startupNotify = false;
            categories = [
                "Utility"
                "TextEditor"
                "Development"
            ];
            settings = {
                Keywords = "Text;editor;vim;nvim";
            };
        };
        "org.musescore.MuseScore" = {
            type = "Application";
            name = "MuseScore Studio";
            genericName = "Music Notation";
            comment = "Create, play and print beautiful sheet music";
            icon = "mscore";
            exec = "env DESKTOPINTEGRATION=false QT_SCALE_FACTOR=1.5 QT_QPA_PLATFORM=wayland mscore %U";
            terminal = false;
            startupNotify = true;
            categories = [
                "AudioVideo"
                "Audio"
                "Graphics"
                "2DGraphics"
                "VectorGraphics"
                "RasterGraphics"
                "Publishing"
                "Midi"
                "Mixer"
                "Sequencer"
                "Music"
                "Qt"
            ];
            settings = {
                Keywords = "music;notation;composition;composing;arranging;making;sheet music;music notation software;lead sheet;leadsheet;score;full score;scorewriter;MIDI;musicxml;playback;instrument";
            };
        };
        mpv = {
            type = "Application";
            name = "MPV Media Player";
            genericName = "Multimedia player";
            comment = "Play movies and songs";
            icon = "mpv";
            exec = "mpv --player-operation-mode=pseudo-gui -- %U";
            terminal = false;
            startupNotify = false;
            categories = [
                "AudioVideo"
                "Audio"
                "Video"
                "Player"
                "TV"
            ];
            settings = {
                Keywords = "mpv;media;player;video;audio;tv";
            };
            noDisplay = true;
        };
    };
}
