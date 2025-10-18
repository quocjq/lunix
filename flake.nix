{
  description = "Lunixose's configuration";

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" ];

      imports = [
        ./hosts
        inputs.home-manager.flakeModules.home-manager
        ./home-manager
        ./parts/dev-shells.nix
        ./parts/overlays.nix
      ];

      perSystem = { config, self', inputs', pkgs, system, ... }: {
        formatter = pkgs.nixfmt-rfc-style;
        packages = { inherit (inputs.quickshell.packages.${system}) default; };
      };
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nix-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # caelestia-shell = {
    #   url = "github:caelestia-dots/shell";
    #   inputs.nixpkgs.follows = "nix-unstable";
    # };
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    # nvf.url = "github:notashelf/nvf";
    nixcord.url = "github:kaylorben/nixcord";
  };
}
