# modules/fonts.nix

{ config, pkgs, lib, ... }:

{
    fonts.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        nerd-fonts.fira-code
    ];
}
