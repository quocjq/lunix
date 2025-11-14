{ inputs, ... }:
{
  flake.homeConfigurations = 
    let
      lib = import ../lib { inherit inputs; };
    in {
      "quocjq@nixos" = lib.generators.mkHome "quocjq" "nixos" {
        profile = "development";
      };

      # add more home configs here
      # "quocjq@laptop" = lib.generators.mkHome "quocjq" "laptop" {
      #   profile = "minimal";
      # };
    };
}
