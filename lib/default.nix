{ inputs, ... }:
let
  inherit (inputs.nixpkgs) lib;
in {
  gen = import ./generators.nix { inherit inputs lib; };
  help = import ./helpers.nix { inherit lib; };
}
