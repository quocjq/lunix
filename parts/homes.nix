{ inputs, ... }:
{
  flake.homeConfigurations =
    let
      lib = import ../lib { inherit inputs; };
    in
    {
      "quocjq@nixos" = lib.gen.mkHome "quocjq" "nixos" {
      };

      # add more home configs here
      # "quocjq@laptop" = lib.generators.mkHome "quocjq" "laptop" {
      # };
    };
}
