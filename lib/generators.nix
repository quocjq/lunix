{ inputs, lib, ... }:
let
  # Helper function to recursively find all .nix files in a directory
  findModules =
    dir:
    let
      # Read directory contents
      entries = builtins.readDir dir;

      # Process each entry
      processEntry =
        name: type:
        let
          path = dir + "/${name}";
        in
        if type == "directory" then
          # Recursively process subdirectories
          findModules path
        else if type == "regular" && lib.hasSuffix ".nix" name then
          # Found a .nix file, return its relative path
          [ (lib.removePrefix (toString ../modules/nixos + "/") (toString path)) ]
        else
          [ ];
    in
    lib.flatten (lib.mapAttrsToList processEntry entries);

  # Get all available modules
  availableModules = findModules ../modules/nixos;

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
  # Generate NixOS host configuration with auto-discovered modules
  mkHost =
    hostname:
    {
      system ? "x86_64-linux",
      users ? { },
      # Auto-generated module options (e.g., DE.hyprland = true;)
      ...
    }@args:
    let
      # Get enabled modules based on args
      enabledModules = lib.filter (
        modPath:
        let
          attrPath = pathToAttrPath modPath;
          # Check if this option exists in args and is true
          optValue = getAttrPath attrPath args;
        in
        optValue == true
      ) availableModules;

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
      ++ map (m: ../modules/nixos + "/${m}") enabledModules;
    };

  # Generate home-manager configuration with auto-discovered modules
  mkHome =
    username: hostname:
    {
      system ? "x86_64-linux",
      ...
    }@args:
    let
      # Similar logic for home modules
      availableHomeModules = findModules ../modules/home;

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
