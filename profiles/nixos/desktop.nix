{ pkgs, ... }: {
  imports = [
    ../../modules/nixos/desktop/hyprland.nix
    ../../modules/nixos/DE/kde.nix
    ../../hosts/common/optional/programs.nix
    ../../hosts/common/optional/services.nix
  ];

  environment.systemPackages = with pkgs; [ firefox libreoffice-qt6-fresh mpv ];
}
