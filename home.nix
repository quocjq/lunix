{ config, pkgs, inputs, ... }: {
  imports = [
    ./modules/home-manager/bash.nix
    ./modules/home-manager/easyeffects.nix
    ./modules/home-manager/kitty.nix
    ./modules/home-manager/tmux.nix
    ./modules/home-manager/starship.nix
    ./modules/home-manager/obs.nix
    ./modules/home-manager/sioyek.nix
    ./modules/home-manager/xdg.nix
  ];

  home.username = "quocjq";
  home.homeDirectory = "/home/quocjq";

  home.file.".config/nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/Lunix/home/nvim";
    recursive = true;
  };

  home.file.".config/quickshell" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/Lunix/home/quickshell";
    recursive = true;
  };

  home.file.".config/hypr" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/Lunix/home/hypr";
    recursive = true;
  };

  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    nix-output-monitor
    nh
    nvd
    zip
    xz
    unzip
    p7zip
    zstd
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder
    dnsutils # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    tree
    gnutar
    gnupg
    btop # replacement of htop/nmon
    lsof # list open files
    sysstat
    pciutils # lspci
    usbutils # lsusb
    neovim
    mpv
    rustup
    lazygit
    firefox
    swww
    waypaper
    pavucontrol
    easyeffects
    fish
    fd
    (pkgs.python3.withPackages
      (python-pkgs: with python-pkgs; [ aubio pyaudio numpy ]))
    cava
    brightnessctl
  ];

  programs.git = {
    enable = true;
    userName = "Bui Vinh Quoc";
    userEmail = "quocjq@gmail.com";
  };

  home.stateVersion = "25.05";
}
