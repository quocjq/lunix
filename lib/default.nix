# lib/default.nix
{ config, ... }: {
  # mkFile function for creating multiple directory symlinks
  mkFile = basePath: directories:
    builtins.listToAttrs (map (dir: {
      name = "${basePath}${dir}";
      value = {
        source = config.lib.file.mkOutOfStoreSymlink
          "${config.home.homeDirectory}/Lunix/home/${dir}";
        recursive = true;
      };
    }) directories);

  # Enhanced version with more options
  mkFileAdvanced =
    { basePath ? ".config/", sourcePath ? "Lunix/home", recursive ? true }:
    directories:
    builtins.listToAttrs (map (dir: {
      name = "${basePath}${dir}";
      value = {
        source = config.lib.file.mkOutOfStoreSymlink
          "${config.home.homeDirectory}/${sourcePath}/${dir}";
        inherit recursive;
      };
    }) directories);
}
