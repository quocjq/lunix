{ pkgs, ... }: {
  # KDE Plasma Desktop Environment
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.autoNumlock = true;
}
