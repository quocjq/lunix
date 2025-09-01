# parts/overlays.nix
{ inputs, ... }: {
  flake.overlays = {
    # Custom overlay for quickshell
    quickshell = final: prev: {
      quickshell = inputs.quickshell.packages.${final.system}.default;
    };

    # Custom overlay for caelestia packages
    caelestia = final: prev: {
      caelestia-shell = inputs.caelestia-shell.packages.${final.system}.default;
      caelestia-cli = inputs.caelestia-cli.packages.${final.system}.default;
    };

    # Unstable packages overlay
    unstable = final: prev: {
      unstable = import inputs.nix-unstable {
        system = final.system;
        config.allowUnfree = true;
      };
    };

    # Default overlay combining all
    default = final: prev:
      (inputs.self.overlays.quickshell final prev)
      // (inputs.self.overlays.caelestia final prev)
      // (inputs.self.overlays.unstable final prev);
  };
}
