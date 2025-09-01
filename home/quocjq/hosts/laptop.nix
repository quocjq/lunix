# home/quocjq/hosts/laptop.nix
{ config, pkgs, ... }: {
  # Laptop-specific Hypr configuration
  home.file.".config/hypr" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/Lunix/home/hypr-laptop";
    recursive = true;
  };

  # Laptop-specific packages (more conservative selection)
  home.packages = with pkgs; [
    # Essential GUI applications only
    firefox
    pavucontrol

    # Laptop power management tools
    powertop
    acpi

    # Lightweight alternatives
    brightnessctl
  ];

  # Laptop-specific settings
  xresources.properties = {
    "Xcursor.size" = 24; # Larger cursor for laptop screen
    "Xft.dpi" = 144; # Adjusted DPI for laptop
  };
}
