# System management
{ self, ... }:
{
  flake.nixosConfigurations = {
    nixos = self.lib.gen.mkHost "nixos" {
      users.quocjq = {
        isMainUser = true;
      };

      # Enable modules using dot notation based on their directory structure
      services.kanata = true;
      services.syncthing = true;

      programs.spicetify = true;
      programs.emacs = true;

      DM.sddm = true;
      DE.hyprland = true;
      # DE.kde = true;  # Alternative DE
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
