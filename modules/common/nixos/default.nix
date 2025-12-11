{ hostname, pkgs, ... }:
{
  imports = [
    ./boot.nix
    ./networking.nix
    ./nix.nix
    ./users.nix
    ./env.nix
    ./programs.nix
    ./services.nix
    ./container.nix
    ./printing.nix
  ];

  networking.hostName = hostname;

  xdg = {
    portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
    };
  };
  # Enable flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "25.05";
}
