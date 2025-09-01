# hosts/laptop/default.nix
{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    # Add laptop-specific disko config if different
    # ./disko.nix 
  ];

  # Laptop-specific packages (lighter selection)
  environment.systemPackages = with pkgs;
    [
      # Essential tools only
      typst
      # Add other laptop-specific packages
    ];

  # Laptop-specific services
  services = {
    # Power management for laptops
    tlp.enable = true;
    # Disable KDE for laptop - use lighter DE or WM
    displayManager.sddm.enable = false;
    xserver = {
      enable = true;
      displayManager.lightdm.enable = true;
      # Use a lighter window manager
      windowManager.i3.enable = true;
    };
  };

  # Power management
  powerManagement.enable = true;

  # Laptop-specific modules
  imports = [
    ../../modules/nixos/laptop.nix
    ../../modules/nixos/hyprland.nix # Still use Hyprland but configured for laptop
  ];
}
