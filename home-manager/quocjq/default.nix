{ config, pkgs, hostName ? null, ... }: {
  imports = [
    ../../modules/home-manager/bash.nix
    ../../modules/home-manager/kitty.nix
    ../../modules/home-manager/tmux.nix
    ../../modules/home-manager/starship.nix
    ../../modules/home-manager/xdg.nix
    ../../modules/home-manager/git.nix
  ] ++ (if hostName == "nixos" then
    [ ./hosts/nixos.nix ]
  else if hostName == "laptop" then
    [ ./hosts/laptop.nix ]
  else if hostName == "server" then
    [ ./hosts/server.nix ]
  else
    [ ]);

  # Enable home-manager
  programs.home-manager.enable = true;
  home.username = "quocjq";
  home.homeDirectory = "/home/quocjq";

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
