{
  inputs,
  lib,
  ...
}:
let
  helpers = import ./gen-helpers.nix { inherit inputs lib; };
in
{
  # Generate NixOS host configuration
  mkHost =
    hostname: args:
    let
      users = args.users or { };
      diskoConfig = args.disko or null;
      hardwareConfig = args.hardware or null;
      homeConfig = args.home or null;
      username =
        if homeConfig != null && homeConfig ? username then
          homeConfig.username
        else
          (users |> builtins.attrNames |> builtins.head);
      baseModules = [
        inputs.disko.nixosModules.disko
        ../modules/common/nixos
        { nixpkgs.overlays = [ inputs.self.overlays.default ]; }
      ];

      diskoModule =
        diskoConfig |> (cfg: if cfg != null then [ (../resources/disko + "/${cfg}.nix") ] else [ ]);

      hardwareModules =
        hardwareConfig |> (cfg: if cfg != null then [ (../resources/hardware + "/${cfg}.nix") ] else [ ]);

      enabledNixosModules =
        ../modules/nixos
        |> helpers.findModules
        |> (modules: helpers.filterEnabledModules modules args)
        |> map (m: ../modules/nixos + "/${m}");

      homeManagerModule =
        homeConfig
        |> (cfg: if cfg != null then helpers.mkHomeManagerModule cfg users hostname username else [ ]);

      allModules =
        baseModules ++ diskoModule ++ hardwareModules ++ enabledNixosModules ++ homeManagerModule;

    in
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit
          inputs
          hostname
          users
          username
          ;
        mylib = import ../lib { inherit inputs; };
      };
      modules = allModules;
    };
}
