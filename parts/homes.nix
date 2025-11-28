# User management
{ self, ... }:
{
  flake.homeConfigurations = {
    "quocjq@nixos" = self.lib.gen.mkHome "quocjq" "nixos" {
      modules = [

        "system/noctalia.nix"
        # "system/caelestia.nix"

        "programs/terminals/kitty.nix"
        "programs/media/easyeffects.nix"
        "programs/media/obs.nix"
        "programs/media/sioyek.nix"
        "programs/communication/nixcord.nix"
      ];
    };

    # add more home configs here
    # "quocjq@laptop" = lib.generators.mkHome "quocjq" "laptop" {
    # };
  };
}
