{ username, pkgs, ... }:
{
  imports = [
    ./bash.nix
    ./git.nix
    ./starship.nix
    ./tmux.nix
    ./xdg.nix
  ];
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 22;
  };
  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";
  };
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 7d --keep 5";
    };
    flake = "/home/${username}/lunix";
  };
  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
  };
  programs.home-manager.enable = true;
  # nixpkgs.config.allowUnfree = true;
}
