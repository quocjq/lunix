# main/overlays.nix
{ inputs, self, ... }:
let
  overlaysList = self.lib.overlays.loadOverlays ../overlays { inherit inputs; };
in
{
  flake.overlays.default =
    final: prev: builtins.foldl' (acc: overlay: acc // (overlay final prev)) { } overlaysList;
}
