{ inputs, lib, ... }: {
  # Generate NixOS host configuration
  mkHost = hostname:
    { system ? "x86_64-linux", modules ? [ ], users ? { }, profile ? null, }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs hostname users;
        customLib = import ../lib { inherit inputs; };
      };
      modules = [
        inputs.disko.nixosModules.disko
        ../overlays
        ../hosts/common
        ../hosts/${hostname}
      ] ++ (lib.optional (profile != null) ../profiles/nixos/${profile}.nix)
        ++ modules;
    };

  # Generate home-manager configuration
  mkHome = username: hostname:
    { system ? "x86_64-linux", modules ? [ ], profile ? null, }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      extraSpecialArgs = {
        inherit inputs hostname username;
        customLib = import ../lib { inherit inputs; };
      };
      modules = [ ../home/${username} ../home/${username}/${hostname}.nix ]
        ++ (lib.optional (profile != null) ../profiles/home/${profile}.nix)
        ++ modules;
    };
}
