{ inputs, ... }:
let
  lib = import ../lib { inherit inputs; };
in
{
  flake.nixosConfigurations = lib.generators.mkHosts {
    # Desktop machine with GNOME
    nixos = {
      system = "x86_64-linux";
      profile = "desktop";
      desktop = "gnome";  # Enable GNOME desktop environment
      
      users = {
        quocjq = {
          isMainUser = true;
          homeProfile = "development";
        };
      };
    };

    # Example: Laptop configuration with KDE
    # laptop = {
    #   system = "x86_64-linux";
    #   profile = "desktop";
    #   desktop = "kde";  # Enable KDE desktop environment
    #
    #   users = {
    #     quocjq = {
    #       isMainUser = true;
    #       homeProfile = "minimal";
    #     };
    #   };
    # };

    # Example: Server configuration (no desktop)
    # server = {
    #   system = "x86_64-linux";
    #   profile = "server";
    #   # No desktop environment for servers
    #
    #   users = {
    #     quocjq = {
    #       isMainUser = true;
    #       homeProfile = "minimal";
    #     };
    #     admin = {
    #       homeProfile = "minimal";
    #     };
    #   };
    # };

    # Example: Desktop with Hyprland
    # hyprland-pc = {
    #   system = "x86_64-linux";
    #   profile = "desktop";
    #   desktop = "hyprland";  # Enable Hyprland desktop environment
    #
    #   users = {
    #     quocjq = {
    #       isMainUser = true;
    #       homeProfile = "development";
    #     };
    #   };
    # };
  };
}
