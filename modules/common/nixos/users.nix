# hosts/common/users.nix
{ users, ... }: {
  # Define users dynamically based on the users parameter
  users.users = builtins.mapAttrs (userName: userConfig: {
    isNormalUser = true;
    description = userName;
    extraGroups = [ "networkmanager" "wheel" ];
    # Use the same password hash for now - you can make this per-user if needed
    initialHashedPassword =
      "$y$j9T$X2ik9Zf6kggwV6DFf3N4S0$DekhCps26lVQqewf.Ex.u5FoDviKimmuTiVGe.OsyUC";
  }) users;
}
