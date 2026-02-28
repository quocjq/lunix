# hosts/common/system.nix
{ pkgs, ... }:
{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Timezone and localization
  time.timeZone = "Asia/Ho_Chi_Minh";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      type = "fcitx5";
      enable = true;
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          catppuccin-fcitx5
          fcitx5-bamboo
        ];
        settings = {
          inputMethod = {
            "Groups/0" = {
              "Name" = "Default";
              "Default Layout" = "us";
              "DefaultIM" = "bamboo";
            };
            "Groups/0/Items/0" = {
              "Name" = "keyboard-us";
              "Layout" = "";
            };
            "Groups/0/Items/1" = {
              "Name" = "bamboo";
              "Layout" = "";
            };
            "GroupOrder" = {
              "0" = "Default";
            };
          };
        };
      };
    };
  };

  # Nix optimization
  nix.optimise = {
    automatic = true;
    dates = [ "17:45" ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 3d";
  };

  # Fonts configuration
  fonts.packages = with pkgs; [
    unstable.nerd-fonts.symbols-only
    unstable.noto-fonts-color-emoji
    noto-fonts-cjk-sans
    unstable.nerd-fonts.jetbrains-mono
  ];

  # Core system packages
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
    caligula
    lm_sensors
    ffmpeg
    gnumake
    bat
    zoxide
    just
    gcc
    wl-clipboard
    neofetch
    dconf
    fd
    fish
    ntfs3g # NOTE Fix hdd for my dad
    gparted
    peazip
    ydotool
    wtype

    # Development
    gittyup
    wget
    neovim
    vscode.fhs
    codex
    texliveBasic
    atlauncher
    steam-run
    zulu
    zulu25
    pkgs.prismlauncher

    # Media
    mpv
    kdePackages.kdenlive
    krita

    # GUI applications
    firefox
    unstable.anki
    obsidian
    onlyoffice-desktopeditors
    onlyoffice-documentserver
  ];
}
