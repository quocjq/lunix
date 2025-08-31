{
  description = "Lunixose's configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nix-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    quickshell = {
      url = "github:quickshell-mirror/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { self, nixpkgs, home-manager, disko, hyprland, quickshell, ... }@inputs:
    let
      inherit (self) outputs;
      # ========== Extend lib with lib.custom ==========
      # NOTE: This approach allows lib.custom to propagate into hm
      lib = nixpkgs.lib.extend
        (self: super: { custom = import ./lib { inherit (nixpkgs) lib; }; });
    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs lib; };
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ({ config, pkgs, ... }: {
            nixpkgs.overlays = [
              (final: prev: {
                quickshell = quickshell.packages.${pkgs.system}.default;
              })
            ];
          })
          inputs.disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          hyprland.nixosModules.default
        ];
      };
    };
}
