# home/quisiou/home.nix


{ config, pkgs, lib, ... }:

{
    imports = [
        ./packages.nix
        ./services.nix
    ];

    home.username = "quisiou";
    home.homeDirectory = "/home/quisiou";
    home.stateVersion = "26.05";

    programs.home-manager.enable = true;
}
