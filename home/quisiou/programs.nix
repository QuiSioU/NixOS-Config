# home/quisiou/programs.nix

{ config, pkgs, lib, ... }:

{
    programs.firefox.enable = true;     # Web browser
    programs.bash = {
        enableCompletion = true;        # Self-explanatory, innit?
        shellAliases = {
            nrs = "sudo nixos-rebuild switch    --flake /home/quisiou/NixOS-Config#chirimbolo";
            nrb = "sudo nixos-rebuild dry-build --flake /home/quisiou/NixOS-Config#chirimbolo";
        };
    };
    programs.git = {
        enable = true;
        settings = {
            user = {
                name = "QuiSioU";
                email = "marco.casteleiro@gmail.com";
            };
        };
    };
}
