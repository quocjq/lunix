{ inputs, ... }:
{
  flake.nixosConfigurations =
    let
      lib = import ../lib { inherit inputs; };
    in
    {
      nixos = lib.gen.mkHost "nixos" {
        users.quocjq = {
          isMainUser = true;
        };
      };

      # Add more hosts here
      # laptop = lib.generators.mkHost "laptop" {
      #   users.quocjq = {};
      # };
    };
}
