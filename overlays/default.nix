{ mylib, ... }:
{
  nixpkgs.overlays = mylib.overlays.mkOverlays ./.;
}
