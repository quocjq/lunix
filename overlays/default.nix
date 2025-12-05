{ inputs, ... }:
{
  nixpkgs.overlays = [
    (import ./unstable.nix { inherit inputs; })
    (import ./caelestia.nix { inherit inputs; })
    (import ./noctalia.nix { inherit inputs; })
    (import ./lib.nix { inherit inputs; })
    (import ./custom-pkgs.nix)
  ];
}
