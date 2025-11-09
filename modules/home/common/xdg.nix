{ pkgs, ... }: {
  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps = { enable = true; };
    portal = {
      enable = true;
      config.common.default = "*";
      extraPortals =
        [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-hyprland ];
    };
  };

}
