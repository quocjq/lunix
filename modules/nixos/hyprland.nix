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
    libsecret
    seahorse
    libnotify # Required by apps to send notifications
    killall # Restart processes
    hyprpolkitagent
  ];
  environment.etc."/xdg/menus/applications.menu".text = builtins.readFile
    "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
  xdg.menus.enable = true;

  security.polkit.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
  };
}
