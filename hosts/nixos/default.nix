# hosts/nixos/default.nix
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Media
    mpv
    kdePackages.kdenlive
    krita

    # GUI applications
    firefox
    unstable.anki
    unstable.obsidian
    onlyoffice-bin
  ];
}
