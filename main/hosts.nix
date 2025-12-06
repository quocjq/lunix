# System management
{ self, ... }:
{
  flake.nixosConfigurations = {
    nixos = self.lib.gen.mkHost "nixos" {
      users.quocjq = {
        isMainUser = true;
      };
      # Disk configuration
      disko = "latitude3520";

      # Hardware configuration using nixos-hardware
      # Multiple modules for Dell Latitude 3520 (11th gen Intel, laptop)
      hardware = [
        "common-cpu-intel"
        "common-pc-laptop"
        "common-pc-laptop-ssd"
      ];

      # Enable modules
      services.kanata = true;
      services.syncthing = true;
      services.cups = false;

      programs.spicetify = true;
      programs.emacs = true;

      DM.sddm = true;
      DE.hyprland = true;
      DE.kde = false; # Alternative DE
    };

    # Add more hosts with different module configurations
    # laptop = lib.custom.gen.mkHost "laptop" {
    #   users.quocjq = {
    #     isMainUser = true;
    #   };
    #
    #   services.kanata = true;
    #   DE.hyprland = true;
    #   # Different modules for laptop
    # };
  };
}
