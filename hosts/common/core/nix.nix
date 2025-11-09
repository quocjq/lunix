# hosts/common/system.nix
{ pkgs, ... }: {
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
          kdePackages.fcitx5-unikey
          catppuccin-fcitx5
          fcitx5-bamboo
          libsForQt5.fcitx5-qt
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
            "GroupOrder" = { "0" = "Default"; };
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
    neovim
    wget
    python314
    nodejs_24
    fd
    wl-clipboard
    lua
    ffmpeg
    gnumake
    bat
    zoxide
    just
    gcc
    neofetch
    dconf
    lm_sensors
    caligula
  ];
}
