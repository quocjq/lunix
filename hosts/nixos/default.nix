# hosts/nixos/default.nix
{ pkgs, ... }: {
  imports = [

    # Hardware 
    ./hardware-configuration.nix
    ./disko.nix

    # Modules
    ../../modules/nixos/hyprland.nix
    ../../modules/nixos/kanata.nix
    ../../modules/nixos/syncthing.nix
    ../../modules/nixos/kde.nix
    ../../modules/nixos/spicetify.nix

  ];

  # Host-specific packages
  environment.systemPackages = with pkgs; [

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
    caligula

    # Development
    rustup
    lazygit
    typst

    # Media
    mpv
    kdePackages.kdenlive

    # Terminal
    fish
    fd

    # GUI applications
    firefox
    easyeffects
    # geogebra
    libreoffice-qt6-fresh
    wxmaxima
    anki-bin

  ];
}
