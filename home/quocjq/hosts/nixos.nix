# home/quocjq/hosts/nixos.nix
{ config, pkgs, ... }: {
  imports = [
    ../../../modules/home-manager/easyeffects.nix
    ../../../modules/home-manager/obs.nix
    ../../../modules/home-manager/sioyek.nix
  ];

  # Desktop-specific symlinks
  home.file.".config/quickshell" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/Lunix/home/Impure/quickshell";
    recursive = true;
  };

  home.file.".config/hypr" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/Lunix/home/Impure/hypr";
    recursive = true;
  };

  # Desktop-specific packages
  home.packages = with pkgs; [
    # GUI applications
    firefox
    pavucontrol
    easyeffects

    # Desktop environment
    swww
    waypaper
    brightnessctl

    # Audio visualization
    cava
    (pkgs.python3.withPackages
      (python-pkgs: with python-pkgs; [ aubio pyaudio numpy ]))
  ];
}
