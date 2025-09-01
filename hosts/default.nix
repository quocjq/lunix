# hosts/default.nix
{ inputs, ... }: {
  flake.nixosConfigurations = let
    # Common configuration for all hosts
    commonModules = [
      inputs.disko.nixosModules.disko
      inputs.home-manager.nixosModules.home-manager
      ../modules/nixos
    ];

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
        modules = commonModules ++ [ ./common ./${hostName} ] ++ modules;
      };
  in {
    # Main desktop configuration (your current setup)
    nixos = mkHost "nixos" {
      users.quocjq = {
        homeConfig = ../../home/quocjq;
        isMainUser = true;
      };
    };

    # Example: Laptop configuration
    laptop = mkHost "laptop" {
      users.quocjq = {
        homeConfig = ../../home/quocjq;
        isMainUser = true;
      };
      modules = [
        # Add laptop-specific modules here
        ../modules/nixos/laptop.nix
      ];
    };

    # Example: Server configuration
    server = mkHost "server" {
      users.quocjq = {
        homeConfig = ../../home/quocjq/server.nix;
        isMainUser = true;
      };
      modules = [
        # Add server-specific modules here  
        ../modules/nixos/server.nix
      ];
    };
  };
}
