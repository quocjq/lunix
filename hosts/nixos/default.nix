# hosts/nixos/default.nix
{ pkgs, ... }:
{
  imports = [

    ../../modules/nixos/services/kanata.nix
    ../../modules/nixos/services/syncthing.nix
    ../../modules/nixos/programs/spicetify.nix
    ../../modules/nixos/programs/emacs.nix

    ../../modules/nixos/DM/sddm.nix
    ../../modules/nixos/DE/hyprland.nix
    # ../../modules/nixos/DE/kde.nix
    ../../hosts/common/optional/programs.nix
    ../../hosts/common/optional/services.nix
  ];

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
    gittyup

    # Media
    mpv
    kdePackages.kdenlive
    krita

    # Terminal
    fish
    fd

    # GUI applications
    firefox
    easyeffects
    # geogebra
    wxmaxima
    unstable.anki
    unstable.obsidian
    nautilus
    onlyoffice-bin
  ];
}
