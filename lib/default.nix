{ inputs, ... }:
let
  inherit (inputs.nixpkgs) lib;
in
{
  gen = import ./gen.nix { inherit inputs lib; };
  overlays = import ./overlays.nix { inherit inputs lib; };
}
