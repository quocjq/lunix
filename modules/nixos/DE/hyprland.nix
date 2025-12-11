{
  pkgs,
  ...
}:
{
  # Enable Hyprland - Need it here + home-manager
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  services = {
    upower.enable = true;
    udisks2.enable = true;
  };
  hardware.graphics.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1"; # Ozone/discord/wayland

  environment.systemPackages = with pkgs; [
    hypridle
    cliphist
    bluez
    inotify-tools
    app2unit
    fastfetch
    socat
    imagemagick
    adw-gtk3
    unstable.qt6Packages.qt6ct
    xfce.thunar
    libsecret
    libnotify # Required by apps to send notifications
    killall # Restart processes
    hyprpolkitagent
    # unstable.quickshell # Can use it or `quickshell` package in flake input
    brightnessctl
    cava
    # Symbol
    unstable.material-symbols
    unstable.material-design-icons
    unstable.material-icons
    unstable.kdePackages.breeze-icons
    unstable.pavucontrol
  ];
  xdg = {
    menus.enable = true;
    portal.extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
  };
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
