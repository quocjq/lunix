{ inputs, ... }:
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
        myLib = import ../lib { inherit inputs; };
      };
      modules = [
        inputs.disko.nixosModules.disko
        ../hosts/common
        ../hosts/${hostname}
        ../hosts/${hostname}/disko.nix
        ../hosts/${hostname}/hardware-configuration.nix
      ]
      ++ map (m: ../modules/nixos + /${m}) modules;
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
        myLib = import ../lib { inherit inputs; };
      };
      modules = [
        ../home/common
        ../home/${username}
      ]
      ++ map (m: ../modules/home + /${m}) modules;
    };
  # Home-manager standalone setup notonly make workflow discretely but also have errors with `nh`
  # This function is still WIP and not working anytime soon
  # FIXME
  # TODO
  mkNix =
    username: hostname:
    {
      system ? "x86_64-linux",
      modules ? [ ],
    }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs hostname username;
        myLib = import ../lib { inherit inputs; };
      };
      modules = [
        inputs.disko.nixosModules.disko
        inputs.home-manager.nixosModules.home-manager
        ../overlays
        ../hosts/common
        ../hosts/${hostname}
        ../hosts/${hostname}/disko.nix
        ../hosts/${hostname}/hardware-configuration.nix
      ]
      ++ map (m: ../modules/nixos + /${m}) modules
      ++ [
        {
          home-manager.users.${username} =
            import [
              ../overlays
              ../home/common
              ../home/${username}
            ]
            ++ map (m: ../modules/home + /${m}) modules;
        }
      ];
    };
}
