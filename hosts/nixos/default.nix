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

    # Nix tools
    nix-output-monitor
    nh
    nvd

    # Archives
    zip
    xz
    unzip
    p7zip
    zstd

    # Text processing
    ripgrep
    jq
    yq-go

    # System tools
    eza
    fzf
    dnsutils
    ldns
    aria2
    tree
    gnutar
    gnupg
    btop
    lsof
    sysstat
    pciutils
    usbutils

    # Development
    rustup
    lazygit

    # Media
    mpv

    # Terminal
    fish
    fd

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
    # Symbol
    material-symbols
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
}
