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

      # Hardware configuration
      hardware = "latitude3520";

      # Enable modules
      services.kanata = true;
      services.syncthing = true;
      services.cups = false;

      programs.spicetify = true;
      programs.emacs = true;

      DM.sddm = true;
      DE.hyprland = true;
      DE.kde = false;

      # Enable home-manager as NixOS module
      home = {
        username = "quocjq"; # Optional: defaults to first user in users

        # Home-manager modules (same as mkHome)
        shell.noctalia = true;

        programs.terminals.kitty = true;
        programs.media.easyeffects = true;
        programs.media.obs = true;
        programs.media.sioyek = true;
        programs.media.flameshot = true;
        programs.communication.nixcord = true;

        # Symlinks
        symlinks = {
          hypr = true;
          nvim = true;
        };
      };
    };
  };
}
