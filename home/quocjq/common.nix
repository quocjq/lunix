{ ... }: {
  imports = [
    ../modules/programs/terminals/kitty.nix
    ../modules/cli
    ../modules/desktop/common/xdg.nix
    ../modules/shells/caelestia.nix
  ];

  # Note: home.username, home.homeDirectory, and home.stateVersion
  # are now set automatically by the mkHost generator
}
