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
      programs.media.flameshot = true;
      programs.communication.nixcord = true;

      # Make Symlink for config that changed frequently
      # Real function in modules/common/home/default.nix
      symlinks = {
        hypr = true; # Symlinks resources/hypr -> ~/.config/hypr
        nvim = true; # Symlinks resources/nvim -> ~/.config/nvim
      };
    };

    # Add more home configs with different module sets
    # "quocjq@laptop" = lib.custom.gen.mkHome "quocjq" "laptop" {
    #   programs.terminals.kitty = true;
    #   programs.media.sioyek = true;
    # };
  };
}
