{ pkgs, ... }: {

  services.desktopManager.plasma6.enable = true;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    kdepim-runtime
    konsole
    oxygen
    elisa
    ktexteditor
    xwaylandvideobridge
    khelpcenter
    gwenview
    kate
    khelpcenter
    krdp
    discover
  ];

  environment.systemPackages = with pkgs.kdePackages; [ kdeconnect-kde ];

}
