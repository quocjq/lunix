{ pkgs, ... }: {
  # KDE Plasma Desktop Environment
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.autoNumlock = true;
  services.desktopManager.plasma6.enable = true;

  # Exclude unwanted KDE packages
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    kdepim-runtime
    konsole
    oxygen
    elisa
    ktexteditor
    xwaylandvideobridge
    khelpcenter
  ];
  environment.systemPackages = with pkgs.kdePackages; [ kdeconnect-kde ];
}
