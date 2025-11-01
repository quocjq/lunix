{ ... }: {
  imports = [
    ../../modules/home/programs/terminals/kitty.nix
    ../../modules/home/desktop/common/xdg.nix
    ../../modules/home/shells/caelestia.nix
  ];

  home.username = "quocjq";
  home.homeDirectory = "/home/quocjq";
}
