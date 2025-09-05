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

  ];
  # Enable home-manager
  programs.home-manager.enable = true;

  home.file = mkFile ".config/" [ "nvim" ];

  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };

  home.stateVersion = "25.05";
}
