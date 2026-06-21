# home/quisiou/home.nix


{ config, pkgs, lib, ... }:

{
    imports = [
        ./packages.nix
        ./programs.nix
        ./scripts.nix
        ./services.nix
        ./theme.nix
        ./variables.nix
    ];

    home.username = "quisiou";
    home.homeDirectory = "/home/quisiou";
    home.stateVersion = "26.05";

    programs.home-manager.enable = true;
}
