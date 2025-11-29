# User management
{ self, ... }:
{
  flake.homeConfigurations = {
    "quocjq@nixos" = self.lib.gen.mkHome "quocjq" "nixos" {
      # Enable modules using dot notation
      shell.noctalia = true;
      # system.caelestia = true;  # Alternative

      programs.terminals.kitty = true;
      programs.media.easyeffects = true;
      programs.media.obs = true;
      programs.media.sioyek = true;
      programs.communication.nixcord = true;
    };

    # Add more home configs with different module sets
    # "quocjq@laptop" = lib.custom.gen.mkHome "quocjq" "laptop" {
    #   programs.terminals.kitty = true;
    #   programs.media.sioyek = true;
    # };
  };
}
