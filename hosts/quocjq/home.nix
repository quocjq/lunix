{ inputs, config, pkgs, ... }: {

  home.username = "quocjq";
  home.homeDirectory = "/home/quocjq";

  home.file.".config/nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/Lunix/home/nvim";
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
    qutebrowser
    ranger
  ];

  programs.git = {
    enable = true;
    userName = "Bui Vinh Quoc";
    userEmail = "quocjq@gmail.com";
  };

  programs.qutebrowser = {
    enable = true;
    extraConfig = "";
  };

  home.stateVersion = "25.05";
}
