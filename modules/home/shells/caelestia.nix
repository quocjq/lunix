{ inputs, pkgs, ... }: {
  imports = [ inputs.caelestia-shell.homeManagerModules.default ];
  programs.caelestia = {
    enable = true;
    systemd = {
      enable = true; # if you prefer starting from your compositor
      target = "graphical-session.target";
      environment = [ ];
    };
    settings = {
      background = {
        desktopClock.enabled = true;
        # visualiser.enabled = true;
      };
      dashboard = { showOnHover = false; };
      bar = {
        status = {
          showBattery = true;
          # showAudio = true;
        };
        clock.showIcon = false;
      };
      paths.wallpaperDir = "~/Pictures/wallpapers/";
      session = {
        vimKeybinds = true;
        commands = {
          logout = [ "uwsm" "stop" ];
          shutdown = [ "systemctl" "poweroff" ];
          hibernate = [ "systemctl" "hibernate" ];
          reboot = [ "systemctl" "reboot" ];
        };
      };
      launcher = {
        actionPrefix = ";";
        vimKeybinds = true;
      };
      services = {
        audioIncrement = 1;
        useFahrenheit = false;
        useTwelveHourClock = false;
      };
    };
    cli = {
      enable = true; # Also add caelestia-cli to path
      settings = { theme.enableGtk = true; };
    };
  };
  home.packages = with pkgs; [ gpu-screen-recorder ];
}
