# flake.nix


{
    description = "chirimbolo NixOS configuration";

    inputs = {
        nixpkgs.url         =   "github:NixOS/nixpkgs/nixos-unstable";
        nixpkgs-stable.url  =   "github:NixOS/nixpkgs/nixos-26.05";

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";   # Avoids a second nixpkgs evaluation
        };

        nix-vscode-extensions = {
            url = "github:nix-community/nix-vscode-extensions";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, home-manager, nix-vscode-extensions, ... }: {
        nixosConfigurations.chirimbolo = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
                ./hosts/chirimbolo/configuration.nix
                home-manager.nixosModules.home-manager
                {
                    nixpkgs.overlays = [ nix-vscode-extensions.overlays.default ];
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.users.quisiou = import ./home/quisiou/home.nix;
                }
            ];
        };
    };
}
