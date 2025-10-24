{ inputs, ... }:
let
  inherit (inputs.nixpkgs) lib;
in {
  generators = import ./generators.nix { inherit inputs lib; };
  helpers = import ./helpers.nix { inherit lib; };
}
