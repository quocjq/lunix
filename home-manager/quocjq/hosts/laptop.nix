# home-manager/quocjq/hosts/laptop.nix
{ pkgs, ... }: {
  # Laptop-specific configuration
  # You can add modules here
  # imports = [
  #   ../../../modules/home-manager/module.nix
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
