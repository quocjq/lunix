{ pkgs, ... }: {

  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
  };

  # Enable GNOME services
  services.gnome = {
    core-utilities.enable = true;
    sushi.enable = true;
  };

  # GNOME specific packages to exclude (following KDE module pattern)
  environment.gnome.excludePackages = (with pkgs; [
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    epiphany          # Web browser
    geary             # Email client
    gnome-characters
    gnome-contacts
    gnome-maps
    gnome-music
    gnome-weather
    simple-scan
    yelp              # Help browser
    cheese            # Webcam tool
    totem             # Video player
    bijiben           # Notes app
    seahorse          # Password manager
  ]);

  # Essential GNOME packages to keep
  environment.systemPackages = with pkgs; [
    gnome.gnome-tweaks
    gnome.dconf-editor
    gnome.file-roller
    gnome.nautilus
    gnome-text-editor
    gnome.nautilus-python
  ];

  # Enable essential GNOME services
  services.gvfs.enable = true; # Required for file management
  programs.dconf.enable = true;

  # Enable tracker for file indexing (optional but useful)
  services.gnome.tracker-miners.enable = true;
  services.gnome.tracker.enable = true;

}