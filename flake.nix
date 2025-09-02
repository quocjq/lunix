{
  description = "Lunixose's multi-host NixOS configuration with flake-parts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nix-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Flake-parts for better organization
    flake-parts.url = "github:hercules-ci/flake-parts";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "github:quickshell-mirror/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.caelestia-cli.follows = "caelestia-cli";
    };

    caelestia-cli = {
      url = "github:caelestia-dots/cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" ];

      imports = [
        # Import host configurations
        ./hosts
        # Import additional flake parts
        ./parts/dev-shells.nix
        ./parts/overlays.nix
      ];

      # Global configuration shared across all systems
      flake = { };

      perSystem = { config, self', inputs', pkgs, system, ... }: {
        # Per-system configuration
        formatter = pkgs.nixfmt-rfc-style;

        # Make packages available across all systems
        packages = { inherit (inputs.quickshell.packages.${system}) default; };
      };
    };
}
