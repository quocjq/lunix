# System management
{ self, ... }:
{
  flake.nixosConfigurations = {
    nixos = self.lib.gen.mkHost "nixos" {
      users.quocjq = {
        isMainUser = true;
      };

      # Hardware configuration
      disko = "latitude3520";
      hardware = "latitude3520";

      # Enable modules
      services.kanata = true;
      services.syncthing = true;
      services.cups = false;

      programs.spicetify = true;
      programs.emacs = true;

      DM.sddm = false;
      DE.hyprland = true;
      DE.kde = true;

      home = {
        username = "quocjq"; # Optional: defaults to first user in users

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
