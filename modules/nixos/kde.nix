{ pkgs, ... }: {
  # KDE Plasma Desktop Environment
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Exclude unwanted KDE packages
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    kdepim-runtime
    konsole
    oxygen
    kate
    elisa
    ktexteditor
    ark
  ];

}
