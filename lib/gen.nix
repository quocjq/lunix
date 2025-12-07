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
      diskoConfig = args.disko or null;
      hardwareConfig = args.hardware or null;
      baseModules = [
        inputs.disko.nixosModules.disko
        ../overlays
        ../modules/common/nixos
      ];
      diskoModule = if diskoConfig != null then [ (../resources/disko + "/${diskoConfig}.nix") ] else [ ];
      hardwareModules =
        if hardwareConfig != null then [ (../resources/hardware + "/${hardwareConfig}.nix") ] else [ ];
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
        mylib = import ../lib { inherit inputs; };
      };
      modules = [
        inputs.disko.nixosModules.disko
        ../overlays
        ../modules/common/nixos
      ]
      ++ baseModules
      ++ diskoModule
      ++ hardwareModules
      ++ map (m: ../modules/nixos + "/${m}") enabledNixosModules;
    };

  # Generate home-manager configuration
  mkHome =
    username: hostname: args:
    let
      # Extract known parameters
      system = args.system or "x86_64-linux";
      symlinks = args.symlinks or { };
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
        inherit
          inputs
          hostname
          username
          symlinks
          ;
        mylib = import ../lib { inherit inputs; };
      };
      modules = [
        ../overlays
        ../modules/common/home
        # Module to handle config symlinks
        (
          { config, ... }:
          {
            xdg.configFile = lib.mapAttrs' (
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
            ) symlinks;
          }
        )
      ]
      ++ map (m: ../modules/home + "/${m}") enabledHomeModules;
    };
}
