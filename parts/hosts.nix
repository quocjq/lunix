# System management
{ lib, ... }:
{
  flake.nixosConfigurations = {
    nixos = lib.custom.gen.mkHost "nixos" {
      users.quocjq = {
        isMainUser = true;
      };
      modules = [

        "services/kanata.nix"
        "services/syncthing.nix"

        "programs/spicetify.nix"
        "programs/emacs.nix"
        # "../../modules/nixos/programs/noctalia.nix"

        "DM/sddm.nix"
        "DE/hyprland.nix"
        # "../../modules/nixos/DE/kde.nix"
      ];
    };

    # Add more hosts here
    # laptop = lib.generators.mkHost "laptop" {
    #   users.quocjq = {};
    # };
  };
}
