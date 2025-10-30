{ inputs, pkgs, ... }: {
  imports = [ inputs.caelestia-shell.homeManagerModules.default ];
  programs.caelestia = {
    enable = true;
    systemd = {
      enable = true; # if you prefer starting from your compositor
      target = "graphical-session.target";
      environment = [ "QT_QPA_PLATFORMTHEME=qt6ct" ];
    };
    settings = {
      general = {
        apps = {
          terminal = "foot";
          audio = "pavucontrol";
          playback = "mpv";
          explorer = "dolphin";
        };
      };
      background = {
        desktopClock.enabled = true;
        visualiser = {
          enabled = true;
          blur = true;
          autoHide = true;
          rounding = 1;
          spacing = 1;
        };
      };
      bar = {
        clock.showIcon = false;
        status = {
          showBattery = true;
          # showAudio = true;
        };
        entries = [{
          "id" = "logo";
          "enabled" = false;
        }];

      };
      paths.wallpaperDir = "~/Pictures/Wallpapers/";
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
      settings = { theme.enableGtk = false; };
    };
  };
  home.packages = with pkgs; [ gpu-screen-recorder ];
}
