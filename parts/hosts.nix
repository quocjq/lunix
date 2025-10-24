{ inputs, ... }:
{
  flake.nixosConfigurations = 
    let
      lib = import ../lib { inherit inputs; };
    in {
      nixos = lib.generators.mkHost "nixos" {
        users.quocjq = { isMainUser = true; };
        profile = "desktop";
      };

      # Add more hosts here
      # laptop = lib.generators.mkHost "laptop" {
      #   users.quocjq = {};
      #   profile = "laptop";
      # };
    };
}
