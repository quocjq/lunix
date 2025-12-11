# main/overlays.nix
{ inputs, self, ... }:
let
  # Use the helper from lib to load all overlays
  overlaysList = self.lib.overlays.loadOverlays ../overlays { inherit inputs; };
in
{
  flake.overlays.default =
    final: prev: builtins.foldl' (acc: overlay: acc // (overlay final prev)) { } overlaysList;
}
