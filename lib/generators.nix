{ inputs }:
let
  inherit (inputs.nixpkgs) lib;
in
{
  # Generate a NixOS host configuration
  mkHost =
    hostname:
    {
      users ? { },
      profile ? "desktop",
      system ? "x86_64-linux",
      extraModules ? [ ],
    }:
    lib.nixosSystem {
      inherit system;
      
      specialArgs = {
        inherit inputs hostname;
        inherit (inputs) self;
      };

      modules = [
        # Core configuration
        ../hosts/common

        # Host-specific configuration
        ../hosts/${hostname}

        # Profile
        ../profiles/nixos/${profile}.nix

        # Overlays
        ../overlays

        # Home Manager as NixOS module
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            
            # Pass through specialArgs to home-manager
            extraSpecialArgs = {
              inherit inputs;
            };
            
            # Configure users with home-manager
            users = lib.mapAttrs (
              username: userConfig:
              let
                homeProfile = userConfig.homeProfile or profile;
                isMainUser = userConfig.isMainUser or false;
              in
              {
                imports = [
                  # User-specific home configuration
                  ../home/${username}/common.nix
                  
                  # Host-specific home configuration
                  (lib.optional 
                    (builtins.pathExists ../home/${username}/${hostname}.nix)
                    ../home/${username}/${hostname}.nix
                  )
                  
                  # Home profile
                  ../profiles/home/${homeProfile}.nix
                ];

                home = {
                  username = username;
                  homeDirectory = "/home/${username}";
                  stateVersion = "25.05";
                };

                programs.home-manager.enable = true;
                nixpkgs.config.allowUnfree = true;
              }
            ) users;
          };
        }

        # Pass users to system configuration
        {
          _module.args = {
            inherit users;
          };
        }
      ] ++ extraModules;
    };
}
