# modules/networking.nix

{ config, pkgs, lib, ... }:

{
    networking.wireless.iwd.enable = true;
    networking.networkmanager.enable = true;
    networking.networkmanager.wifi.backend = "iwd";
}
