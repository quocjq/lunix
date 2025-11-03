{ config, pkgs, lib, ... }: {

  # Enable Hyprland - Need it here + home-manager
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };
  hardware.graphics.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1"; # Ozone/discord/wayland

  environment.systemPackages = with pkgs; [
    hyprpicker
    hypridle
    cliphist
    bluez
    inotify-tools
    unstable.app2unit
    trash-cli
    fastfetch
    socat
    imagemagick
    adw-gtk3
    libsForQt5.qt5ct
    # qt6ct
    xfce.thunar
    gnome-keyring
    libsecret
    seahorse
    libnotify # Required by apps to send notifications
    killall # Restart processes
    hyprpolkitagent
    # unstable.quickshell # Can use it or `quickshell` package in flake input
    swww
    brightnessctl
    cava
    (pkgs.python3.withPackages
      (python-pkgs: with python-pkgs; [ aubio pyaudio numpy ]))
    # Symbol
    unstable.material-symbols
    caelestia-with-cli
    pavucontrol
  ];
  environment.etc."/xdg/menus/applications.menu".text = builtins.readFile
    "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
  xdg.menus.enable = true;

  security.polkit.enable = true;
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "JetBrains Mono NF:size=11"; # Change font and size as desired
      };
      # Other Foot settings can go here
    };
  };
}
