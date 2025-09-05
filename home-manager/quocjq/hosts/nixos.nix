# home-manager/quocjq/hosts/nixos.nix
{ config, ... }:
let
  mkFile = basePath: directories:
    builtins.listToAttrs (map (dir: {
      name = "${basePath}${dir}";
      value = {
        source = config.lib.file.mkOutOfStoreSymlink
          "${config.home.homeDirectory}/Lunix/home/${dir}";
        recursive = true;
      };
    }) directories);
in {
  imports = [
    ../../../modules/home-manager/easyeffects.nix
    ../../../modules/home-manager/obs.nix
    ../../../modules/home-manager/sioyek.nix
  ];

  # Desktop-specific symlinks
  home.file = mkFile ".config/" [ "quickshell" "hypr" ];
}
