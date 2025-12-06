{ inputs, lib, ... }:
let
  # Helper to find all .nix files except default.nix
  findOverlayFiles =
    dir:
    lib.filterAttrs (
      name: type: type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix"
    ) (builtins.readDir dir);

  # Load a single overlay file
  loadOverlay =
    overlaysDir: name:
    let
      overlayPath = overlaysDir + "/${name}";
      overlayFn = import overlayPath;
    in
    # Handle overlays that take inputs vs those that don't
    if lib.isFunction overlayFn then
      if (lib.functionArgs overlayFn) ? inputs then overlayFn { inherit inputs; } else overlayFn
    else
      overlayFn;
in
{
  # Automatically load all overlay files from a directory
  # Usage: mkOverlays ../overlays
  # Returns: list of overlay functions ready to use in nixpkgs.overlays
  mkOverlays =
    overlaysDir:
    let
      overlayFiles = findOverlayFiles overlaysDir;
    in
    map (loadOverlay overlaysDir) (builtins.attrNames overlayFiles);
}
