{ inputs }:
let
  inherit (inputs.nixpkgs) lib;
  
  # Dynamically read all DE modules from modules/nixos/DE directory
  desktopModules = builtins.listToAttrs (
    map (desktopFile: {
      name = builtins.replaceStrings [".nix"] [""] desktopFile;
      value = ../../../modules/nixos/DE/${desktopFile};
    }) (builtins.attrNames (builtins.readDir ../../../modules/nixos/DE))
  ) // {
    # Add non-DE directory modules manually
    hyprland = ../../../modules/nixos/desktop/hyprland.nix;
  };

in
{
  # Generate multiple NixOS host configurations using scalable architecture
  mkHosts = lib.mapAttrs (hostname: hostConfig:
    let
      desktop = hostConfig.desktop or null;
      desktopModule = if desktop != null then desktopModules.${desktop} else null;
    in
    lib.nixosSystem {
      system = hostConfig.system or "x86_64-linux";
      
      specialArgs = {
        inherit inputs desktop;
        hostname = hostname;
        inherit (inputs) self;
      };

      modules = [
        # Core configuration
        ../hosts/common

        # Host-specific configuration
        ../hosts/${hostname}

        # Profile
        ../profiles/nixos/${hostConfig.profile or "desktop"}.nix

        # Desktop environment module (if specified)
        (lib.optional (desktopModule != null) desktopModule)

        # Overlays
        ../overlays

        # Home Manager as NixOS module
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            
            extraSpecialArgs = {
              inherit inputs desktop;
            };
            
            users = lib.mapAttrs (
              username: userConfig:
              let
                homeProfile = userConfig.homeProfile or (hostConfig.profile or "desktop");
              in
              {
                imports = [
                  ../home/${username}/common.nix
                  
                  (lib.optional
                    (builtins.pathExists ../home/${username}/${hostname}.nix)
                    ../home/${username}/${hostname}.nix
                  )
                  
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
            ) (hostConfig.users or {});
          };
        }

        # Pass configuration to system
        {
          _module.args = {
            inherit (hostConfig) users;
            desktop = desktop;
          };
        }
      ] ++ (hostConfig.extraModules or []);
    }
  );
}
