{
  inputs,
  lib,
  ...
}:
let
  findModules =
    baseDir:
    builtins.readDir baseDir
    |> lib.mapAttrsToList (
      name: type:
      if type == "directory" then
        (baseDir + "/${name}") |> findModules |> map (subPath: "${name}/${subPath}")
      else if type == "regular" && lib.hasSuffix ".nix" name then
        [ name ]
      else
        [ ]
    )
    |> lib.flatten;

  filterEnabledModules =
    availableModules: args:
    availableModules
    |> lib.filter (
      modPath:
      modPath
      |> lib.removeSuffix ".nix"
      |> lib.splitString "/"
      |> builtins.foldl' (
        acc: attr: if acc == false || !builtins.hasAttr attr acc then false else acc.${attr}
      ) args
      |> (v: v == true)
    );

  mkHomeManagerModule = homeConfig: users: hostname: [
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {
          inherit inputs hostname;
          username = (users |> builtins.attrNames |> builtins.head);
          symlinks = homeConfig.symlinks or { };
        };
      }
      // {
        users.${(users |> builtins.attrNames |> builtins.head)} = {
          imports = [
            (
              { config, lib, ... }:
              {
                config = {
                  xdg.configFile =
                    (homeConfig.symlinks or { })
                    |> lib.mapAttrs' (
                      name: enabled:
                      lib.nameValuePair name (
                        if enabled then
                          {
                            source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/lunix/resources/${name}";
                            recursive = true;
                          }
                        else
                          { }
                      )
                    );
                };
              }
            )
          ]
          ++ (
            ../modules/home
            |> findModules
            |> (modules: filterEnabledModules modules homeConfig)
            |> map (m: ../modules/home + "/${m}")
          );
        };
      };
    }
  ];

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
      baseModules = [
        inputs.disko.nixosModules.disko
        inputs.home-manager.nixosModules.home-manager
        ../modules/common/nixos
        ../modules/common/home
        { nixpkgs.overlays = [ inputs.self.overlays.default ]; }
      ];

      diskoModule =
        diskoConfig |> (cfg: if cfg != null then [ (../resources/disko + "/${cfg}.nix") ] else [ ]);

      hardwareModules =
        hardwareConfig |> (cfg: if cfg != null then [ (../resources/hardware + "/${cfg}.nix") ] else [ ]);

      enabledNixosModules =
        ../modules/nixos
        |> findModules
        |> (modules: filterEnabledModules modules args)
        |> map (m: ../modules/nixos + "/${m}");

      homeManagerModule =
        homeConfig |> (cfg: if cfg != null then mkHomeManagerModule cfg users hostname else [ ]);

      allModules =
        baseModules ++ diskoModule ++ hardwareModules ++ enabledNixosModules ++ homeManagerModule;

    in
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit
          inputs
          hostname
          users
          ;
        mylib = import ../lib { inherit inputs; };
      };
      modules = allModules;
    };
}
