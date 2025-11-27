{ inputs, ... }:
{
  flake.homeConfigurations =
    let
      lib = import ../lib { inherit inputs; };
    in
    {
      "quocjq@nixos" = lib.gen.mkHome "quocjq" "nixos" {
        modules = [

          programs/terminals/kitty.nix
          system/noctalia.nix
          # ../modules/home/system/caelestia.nix

          programs/media/easyeffects.nix
          programs/media/obs.nix
          programs/media/sioyek.nix
          programs/communication/nixcord.nix
        ];
      };

      # add more home configs here
      # "quocjq@laptop" = lib.generators.mkHome "quocjq" "laptop" {
      # };
    };
}
