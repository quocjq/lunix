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
        modules = [ ./common ] + [ ./${userName} ] ++ modules;
      };
  in {
    # Main desktop configuration
    "quocjq@nixos" = mkHome "quocjq" { hostName = "nixos"; };

    # Laptop configuration
    "quocjq@laptop" = mkHome "quocjq" {
      hostName = "laptop";
      modules = [
        # Add laptop-specific home modules here if needed
      ];
    };

    # Server configuration  
    "quocjq@server" = mkHome "quocjq" {
      hostName = "server";
      modules = [
        # Add server-specific home modules here if needed
      ];
    };
  };
}
