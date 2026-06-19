# flake.nix


{
    description = "chirimbolo NixOS configuration";

    inputs = {
        nixpkgs.url         =   "github:NixOS/nixpkgs/nixos-unstable";
        nixpkgs-stable.url  =   "github:NixOS/nixpkgs/nixos-26.05";
    };

    outputs = { self, nixpkgs, ... }: {
        nixosConfigurations.chirimbolo = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
                ./hosts/chirimbolo/configuration.nix
            ];
        };
    };
}
