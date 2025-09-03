# parts/overlays.nix
{ inputs, ... }: {
  flake.overlays = {
    # Custom overlay for quickshell
    quickshell = final: prev: {
      quickshell = inputs.quickshell.packages.${final.system}.default;
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
      // (inputs.self.overlays.unstable final prev);
  };

  # Create a nixosModule that applies overlays
  flake.nixosModules.overlays = { ... }: {
    nixpkgs.overlays = [ inputs.self.overlays.default ];
  };
}
