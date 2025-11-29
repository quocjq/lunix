{ inputs, lib, ... }:
let
  # Helper function to find all .nix files in a directory
  findModules =
    baseDir:
    let
      # Scan directory function
      scan =
        dir: prefix:
        let
          entries = builtins.readDir dir;

          processEntry =
            name: type:
            let
              path = dir + "/${name}";
              newPrefix = if prefix == "" then name else "${prefix}/${name}";
            in
            if type == "directory" then
              # Recursively process subdirectories
              scan path newPrefix
            else if type == "regular" && lib.hasSuffix ".nix" name then
              # Found a .nix file, return its relative path without the base dir
              [ newPrefix ]
            else
              [ ];
        in
        lib.flatten (lib.mapAttrsToList processEntry entries);
    in
    scan baseDir "";

  # Get all available modules
  availableNixosModules = findModules ../modules/nixos;
  availableHomeModules = findModules ../modules/home;

  # Convert module path to option name
  # e.g., "DE/hyprland.nix" -> ["DE" "hyprland"]
  pathToAttrPath =
    path:
    let
      withoutExt = lib.removeSuffix ".nix" path;
      parts = lib.splitString "/" withoutExt;
    in
    parts;

  # Get nested attribute value safely
  # e.g., getAttrPath ["DE" "hyprland"] args -> args.DE.hyprland or false
  getAttrPath =
    attrPath: set:
    let
      getAttr' =
        path: s:
        if path == [ ] then
          s
        else if builtins.hasAttr (builtins.head path) s then
          getAttr' (builtins.tail path) (s.${builtins.head path})
        else
          false;
    in
    getAttr' attrPath set;

in
{
  # Generate NixOS host configuration
  mkHost =
    hostname: args:
    let
      # Extract known parameters
      system = args.system or "x86_64-linux";
      users = args.users or { };
      enabledNixosModules = lib.filter (
        modPath:
        let
          attrPath = pathToAttrPath modPath;
          # Check if this option exists in args and is true
          optValue = getAttrPath attrPath args;
        in
        optValue == true
      ) availableNixosModules;

    in
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs hostname users;
        myLib = import ../lib { inherit inputs; };
      };
      modules = [
        inputs.disko.nixosModules.disko
        ../overlays
        ../hosts/common
        ../hosts/${hostname}
        ../hosts/${hostname}/disko.nix
        ../hosts/${hostname}/hardware-configuration.nix
      ]
      ++ map (m: ../modules/nixos + "/${m}") enabledNixosModules;
    };

  # Generate home-manager configuration
  mkHome =
    username: hostname: args:
    let
      # Extract known parameters
      system = args.system or "x86_64-linux";
      enabledHomeModules = lib.filter (
        modPath:
        let
          attrPath = pathToAttrPath modPath;
          optValue = getAttrPath attrPath args;
        in
        optValue == true
      ) availableHomeModules;

    in
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      extraSpecialArgs = {
        inherit inputs hostname username;
        myLib = import ../lib { inherit inputs; };
      };
      modules = [
        ../overlays
        ../home/common
        ../home/${username}
      ]
      ++ map (m: ../modules/home + "/${m}") enabledHomeModules;
    };
}
