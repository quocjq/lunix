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
              scan path newPrefix
            else if type == "regular" && lib.hasSuffix ".nix" name then
              [ newPrefix ]
            else
              [ ];
        in
        entries |> lib.mapAttrsToList processEntry |> lib.flatten;
    in
    scan baseDir "";

  # Get all available modules
  availableNixosModules = findModules ../modules/nixos;
  availableHomeModules = findModules ../modules/home;

  # Convert module path to option name
  # e.g., "DE/hyprland.nix" -> ["DE" "hyprland"]
  pathToAttrPath = path: path |> lib.removeSuffix ".nix" |> lib.splitString "/";

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
          s.${builtins.head path} |> getAttr' (builtins.tail path)
        else
          false;
    in
    getAttr' attrPath set;

  # Filter modules based on enabled flags in args
  filterEnabledModules =
    availableModules: args:
    availableModules
    |> lib.filter (
      modPath:
      modPath |> pathToAttrPath |> (attrPath: getAttrPath attrPath args) |> (optValue: optValue == true)
    );

  # Build home-manager module configuration
  mkHomeManagerModule =
    homeConfig: users: hostname:
    let
      username = homeConfig.username or (users |> builtins.attrNames |> builtins.head);
      symlinks = homeConfig.symlinks or { };

      enabledHomeModules =
        availableHomeModules
        |> (modules: filterEnabledModules modules homeConfig)
        |> map (m: ../modules/home + "/${m}");

      symlinkModule =
        { config, lib, ... }:
        {
          config = {
            # Disable xdg.portal in home-manager (use system-level config instead)
            xdg.portal.enable = lib.mkForce false;

            xdg.configFile =
              symlinks
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
        };
    in
    [
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {
            inherit
              inputs
              hostname
              username
              symlinks
              ;
            mylib = import ../lib { inherit inputs; };
          };
          users.${username} = {
            imports = [
              ../modules/common/home
              symlinkModule
            ]
            ++ enabledHomeModules;
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
      # Extract known parameters
      system = args.system or "x86_64-linux";
      users = args.users or { };
      diskoConfig = args.disko or null;
      hardwareConfig = args.hardware or null;
      homeConfig = args.home or null;

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
        availableNixosModules
        |> (modules: filterEnabledModules modules args)
        |> map (m: ../modules/nixos + "/${m}");

      homeManagerModule =
        homeConfig |> (cfg: if cfg != null then mkHomeManagerModule cfg users hostname else [ ]);

      allModules =
        baseModules ++ diskoModule ++ hardwareModules ++ enabledNixosModules ++ homeManagerModule;

    in
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs hostname users;
        mylib = import ../lib { inherit inputs; };
      };
      modules = allModules;
    };

  # Generate home-manager configuration (standalone)
  mkHome =
    username: hostname: args:
    let
      system = args.system or "x86_64-linux";
      symlinks = args.symlinks or { };

      enabledHomeModules =
        availableHomeModules
        |> (modules: filterEnabledModules modules args)
        |> map (m: ../modules/home + "/${m}");

      symlinkModule =
        { config, ... }:
        {
          xdg.configFile =
            symlinks
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

      allModules = [
        ../modules/common/home
        symlinkModule
      ]
      ++ enabledHomeModules;

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
      modules = allModules;
    };
}
