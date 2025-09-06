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
      fcitx5.addons = with pkgs; [ fcitx5-bamboo ];
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
    nerd-fonts.symbols-only
    noto-fonts-emoji
    noto-fonts-cjk-sans
    font-awesome
    material-icons
    nerd-fonts.jetbrains-mono
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
