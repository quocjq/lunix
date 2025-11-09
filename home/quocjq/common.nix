{ pkgs, ... }: {
  imports = [
    ../../modules/home/programs/terminals/kitty.nix
    ../../modules/home/system/caelestia.nix
  ];
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 22;
  };
  home.username = "quocjq";
  home.homeDirectory = "/home/quocjq";
}
