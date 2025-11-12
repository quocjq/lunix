{ pkgs, ... }: {
  imports = [
    ../../modules/nixos/DM/sddm.nix
    ../../modules/nixos/DE/hyprland.nix
    # ../../modules/nixos/DE/kde.nix
    ../../hosts/common/optional/programs.nix
    ../../hosts/common/optional/services.nix
  ];

  environment.systemPackages = with pkgs; [
    firefox
    onlyoffice-bin
    mpv
    gittyup
  ];
}
