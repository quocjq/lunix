{ inputs, ... }:
{
  # This file is now optional since home-manager is configured as a NixOS module
  # Keep it only if you need standalone home-manager configurations (non-NixOS systems)
  
  flake.homeConfigurations = {
    # Example standalone home-manager configuration for non-NixOS systems
    # "quocjq@macos" = inputs.home-manager.lib.homeManagerConfiguration {
    #   pkgs = import inputs.nixpkgs {
    #     system = "aarch64-darwin";
    #     config.allowUnfree = true;
    #   };
    #   
    #   extraSpecialArgs = {
    #     inherit inputs;
    #   };
    #   
    #   modules = [
    #     ../home/quocjq/common.nix
    #     ../profiles/home/minimal.nix
    #     {
    #       home = {
    #         username = "quocjq";
    #         homeDirectory = "/Users/quocjq";
    #         stateVersion = "25.05";
    #       };
    #       programs.home-manager.enable = true;
    #     }
    #   ];
    # };
  };
}
