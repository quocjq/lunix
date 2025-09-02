{ pkgs, ... }: {
  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps = { enable = true; };
    portal = {
      enable = true;
      config.common.default = "*";
      extraPortals = [
        pkgs.kdePackages.xdg-desktop-portal-kde # Replace with your compositor's package
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-hyprland
      ];
    };
  };

}
