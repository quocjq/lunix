# hosts/nixos/default.nix
{ pkgs, inputs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    # Host-specific modules
    ../../modules/nixos/hyprland.nix
    ../../modules/nixos/kanata.nix
    ../../modules/nixos/syncthing.nix
  ];

  # Host-specific packages
  environment.systemPackages = with pkgs; [
    geogebra
    tmux-sessionizer
    typst
    kdePackages.kdenlive
    libreoffice-qt6-fresh
    caligula
    quickshell
  ];

  # KDE Plasma Desktop Environment
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Exclude unwanted KDE packages
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    kdepim-runtime
    konsole
    oxygen
    kate
    elisa
    ktexteditor
    ark
  ];

  # Add quickshell overlay
  nixpkgs.overlays = [
    (final: prev: {
      quickshell = inputs.quickshell.packages.${pkgs.system}.default;
    })
  ];
}
