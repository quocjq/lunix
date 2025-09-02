# hosts/default.nix
{ inputs, ... }: {
  flake.nixosConfigurations = let
    # Helper function to create host configuration
    mkHost = hostName:
      { system ? "x86_64-linux", modules ? [ ], users ? { } }:
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          hostName = hostName;
          inherit users;
        };
        modules = [
          # Import disko for disk management
          inputs.disko.nixosModules.disko
          ./common
          ./${hostName}
        ] ++ modules;
      };
  in {
    # Main desktop configuration
    nixos = mkHost "nixos" { users.quocjq = { isMainUser = true; }; };

    # Example: Laptop configuration
    laptop = mkHost "laptop" {
      users.quocjq = { };
      modules = [
        # Add laptop-specific modules here
        ../modules/nixos/laptop.nix
      ];
    };

    # Example: Server configuration
    server = mkHost "server" {
      users.quocjq = { };
      modules = [
        # Add server-specific modules here  
        ../modules/nixos/server.nix
      ];
    };
  };
}
