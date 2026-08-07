# modules/hardware.nix

{ config, pkgs, lib, ... }:

{
    hardware = {
        steam-hardware.enable = true;
        uinput.enable = true;
    };
}
