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

    catppuccin = {
      url = "github:catppuccin/nix";
    };
  };

  outputs = { self, nixpkgs, home-manager, hyprland, niri, ... }@inputs:
  let
    hostPlatform = "x86_64-linux";

    pkgs = import nixpkgs {
      system = hostPlatform;

      config = {
        allowUnfree = true;
      };
    };

  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit pkgs;

      specialArgs = {
        inherit inputs;
      };

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

        inputs.catppuccin.nixosModules.catppuccin

        home-manager.nixosModules.home-manager

        {
          nixpkgs.hostPlatform = hostPlatform;

          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";

          home-manager.extraSpecialArgs = {
            inherit inputs;
          };

          home-manager.users.ipriyansh =
            import ./home/home.nix;
        }
      ];
    };
  };
}
