{ inputs, ... }: {
  nixpkgs.overlays = [
    (import ./unstable.nix { inherit inputs; })
    (import ./caelestia.nix { inherit inputs; })
  ];
}
