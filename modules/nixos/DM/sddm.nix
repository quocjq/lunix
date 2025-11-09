{ pkgs, ... }: {
  services.displayManager.sddm.autoNumlock = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.sddm = {
    enable = true;
    theme = "sddm-astronaut-theme";
  };
  environment.systemPackages = with pkgs; [ sddm-astronaut ];
}
