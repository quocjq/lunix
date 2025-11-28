{ inputs, ... }:
[
  (import ./lib.nix { inherit inputs; })
  (import ./unstable.nix { inherit inputs; })
  (import ./noctalia.nix { inherit inputs; })
  (import ./caelestia.nix { inherit inputs; })
]
