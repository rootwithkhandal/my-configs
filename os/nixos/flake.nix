{
  description = "NixOS config — Pentesting / RE / DFIR / Bug Bounty multi-DE";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:YaLTeR/niri";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, hyprland, niri, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs   = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        ./hardware-configuration.nix
        ./modules/core.nix
        ./modules/desktops.nix
        ./modules/security.nix
        ./modules/virtualization.nix
        ./modules/networking.nix
        ./modules/pentesting.nix
        ./modules/dfir.nix
        ./modules/malware.nix
        ./modules/bugbounty.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs   = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users.ipriyansh = import ./home/home.nix;
        }
      ];
    };
  };
}
