{ inputs, ... }:
let
  lib = import ../lib { inherit inputs; };
in
{
  flake.nixosConfigurations = {
    # Desktop machine
    nixos = lib.generators.mkHost "nixos" {
      system = "x86_64-linux";
      profile = "desktop";
      
      users = {
        quocjq = {
          isMainUser = true;
          homeProfile = "development";
        };
      };
    };

    # Example: Laptop configuration
    # laptop = lib.generators.mkHost "laptop" {
    #   system = "x86_64-linux";
    #   profile = "desktop";
    #   
    #   users = {
    #     quocjq = {
    #       isMainUser = true;
    #       homeProfile = "minimal";
    #     };
    #   };
    # };

    # Example: Server configuration
    # server = lib.generators.mkHost "server" {
    #   system = "x86_64-linux";
    #   profile = "server";
    #   
    #   users = {
    #     quocjq = {
    #       isMainUser = true;
    #       homeProfile = "minimal";
    #     };
    #     admin = {
    #       homeProfile = "minimal";
    #     };
    #   };
    # };
  };
}
