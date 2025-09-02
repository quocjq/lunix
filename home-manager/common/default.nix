{ config, pkgs, hostName ? null, userName, ... }: {

  imports = [
    # Add core utils
    ./bash.nix
    ./git.nix
    ./starship.nix
    ./tmux.nix
  ];

  home.username = userName;
  home.homeDirectory = "/home/${userName}";

  home.file.".config/nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/Lunix/home/nvim";
    recursive = true;
  };

  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };

  home.stateVersion = "25.05";
}
