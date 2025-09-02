{ config, pkgs, inputs, hostName, ... }: {
  imports = [
    ./nixos.nix
    ../../modules/home-manager/bash.nix
    ../../modules/home-manager/kitty.nix
    ../../modules/home-manager/tmux.nix
    ../../modules/home-manager/starship.nix
    ../../modules/home-manager/xdg.nix
    ../../modules/home-manager/git.nix
  ];

  home.username = "quocjq";
  home.homeDirectory = "/home/quocjq";
  # Symlink configurations
  home.file.".config/nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/Lunix/home/Impure/nvim";
    recursive = true;
  };

  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };

  # Core packages available on all hosts
  home.packages = with pkgs; [
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
  ];

  home.stateVersion = "25.05";
}
