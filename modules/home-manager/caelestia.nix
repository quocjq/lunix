{ inputs, pkgs, ... }:
let caelestia = inputs.caelestia-shell.packages.${pkgs.system}.default;
in {
  programs.caelestia = {
    enable = true;
    packagee = caelestia;
    systemd = {
      enable = false; # if you prefer starting from your compositor
      target = "graphical-session.target";
      environment = [ ];
    };
    settings = {
      bar.status = { showBattery = false; };
      paths.wallpaperDir = "~/Lunix/wallpapers";
    };
    cli = {
      enable = true; # Also add caelestia-cli to path
      settings = { theme.enableGtk = false; };
    };
  };
}
