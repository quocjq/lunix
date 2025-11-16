{
  pkgs,
  username,
  lib,
  ...
}:
{
  imports = [

    ../../modules/home/programs/terminals/kitty.nix
    ../../modules/home/system/caelestia.nix

    ../../modules/home/programs/media/easyeffects.nix
    ../../modules/home/programs/media/obs.nix
    ../../modules/home/programs/media/sioyek.nix
    ../../modules/home/programs/communication/nixcord.nix
  ];

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 22;
  };

  home.packages = with pkgs; [
    rustup
    nodejs_24
    typst
  ];

}
