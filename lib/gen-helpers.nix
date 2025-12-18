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

  mkHomeManagerModule = homeConfig: users: hostname: username: [
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {
          inherit inputs hostname username;
          symlinks = homeConfig.symlinks or { };
        };
      }
      // {
        users.${username} = {
          imports = [
            ../modules/common/home
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
  inherit
    findModules
    filterEnabledModules
    mkHomeManagerModule
    ;
}
