{ lib, ... }:
{
  # Automatically discover and load all overlay files from a directory
  # Usage: loadOverlays ../overlays { inherit inputs; }
  # Returns: list of overlay functions ready to use
  loadOverlays =
    overlaysDir: args:
    let
      # Load a single overlay file
      loadOverlay =
        name:
        let
          overlayPath = overlaysDir + "/${name}";
          overlayFn = import overlayPath;
        in
        # If overlay needs inputs, pass them; otherwise call directly
        if lib.isFunction overlayFn && (lib.functionArgs overlayFn) != { } then
          overlayFn args
        else
          overlayFn;
    in
    overlaysDir
    |> builtins.readDir
    |> lib.filterAttrs (
      name: type: type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix"
    )
    |> builtins.attrNames
    |> map loadOverlay;
}
