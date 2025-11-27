{ inputs, lib, ... }:
{
  # Generate NixOS host configuration
  mkHost =
    hostname:
    {
      system ? "x86_64-linux",
      modules ? [ ],
      users ? { },
    }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs hostname users;
        customLib = import ../lib { inherit inputs; };
      };
      modules = [
        inputs.disko.nixosModules.disko
        ../overlays
        ../hosts/common
        ../hosts/${hostname}
        ../hosts/${hostname}/disko.nix
        ../hosts/${hostname}/hardware-configuration.nix
      ]
      ++ modules;
    };

  # Generate home-manager configuration
  mkHome =
    username: hostname:
    {
      system ? "x86_64-linux",
      modules ? [ ],
    }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      extraSpecialArgs = {
        inherit inputs hostname username;
        customLib = import ../lib { inherit inputs; };
      };
      modules = [
        ../overlays
        ../home/common
        ../home/${username}
      ]
      ++ map (m: ../modules/home + /${m}) modules;
    };
}
