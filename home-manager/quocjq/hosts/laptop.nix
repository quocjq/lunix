# home-manager/quocjq/hosts/laptop.nix
{ config, pkgs, ... }: {
  # Laptop-specific configuration
  # You can add laptop-specific imports here
  # imports = [
  #   ../../../modules/home-manager/laptop-specific.nix
  # ];

  # Laptop-specific packages
  home.packages = with pkgs; [
    # Power management tools
    powertop
    tlp

    # Laptop utilities
    brightnessctl
    acpi
  ];

  # Laptop-specific services or configurations
  # services.gpg-agent.enable = true;
}
