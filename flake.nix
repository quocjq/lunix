{
  description = "Lunixose's configuration";

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" ];

      imports = [
        # Import host configurations
        ./hosts
        # Import home-manager configurations
        inputs.home-manager.flakeModules.home-manager
        ./home-manager
        # Import additional flake parts
        ./parts/dev-shells.nix
        ./parts/overlays.nix
      ];

      perSystem = { config, self', inputs', pkgs, system, ... }: {
        # Per-system configuration
        formatter = pkgs.nixfmt-rfc-style;

        # Make packages available across all systems
        packages = { inherit (inputs.quickshell.packages.${system}) default; };
      };
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nix-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Flake-parts for better organization
    flake-parts.url = "github:hercules-ci/flake-parts";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Widget system that very nice
    quickshell = {
      url = "github:quickshell-mirror/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Manage hardware config
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nix-unstable";
    };
  };
}
