# home-manager/default.nix
{ inputs, ... }: {
  flake.homeConfigurations = let
    # Helper function to create home-manager configuration
    mkHome = userName:
      { system ? "x86_64-linux", hostName ? null, modules ? [ ] }:
      inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        extraSpecialArgs = {
          inherit inputs;
          hostName = hostName;
        };
        modules = [ ./common ./${userName} ./${userName}/hosts/${hostName}.nix ]
          ++ modules;
      };
  in {
    # Main desktop configuration
    "quocjq@nixos" = mkHome "quocjq" {
      hostName = "nixos";
      modules = [
        # Add modules
      ];
    };
  };
}
