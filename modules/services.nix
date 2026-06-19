# modules/services.nix

{ config, pkgs, lib, ... }:

{
    services.blueman.enable = true;
    services.avahi.enable = true;
    services.printing.enable = true;     # CUPS
}
