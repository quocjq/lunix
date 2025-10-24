{ ... }: {
  imports = [
    ../modules/programs/terminals/kitty.nix
    ../modules/cli
    ../modules/desktop/common/xdg.nix
    ../modules/shells/caelestia.nix
  ];

  home.username = "quocjq";
  home.homeDirectory = "/home/quocjq";
}
