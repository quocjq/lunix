# modules/nixos/server.nix
{ config, pkgs, ... }: {
  # Server optimizations
  boot.kernel.sysctl = {
    # Network optimizations
    "net.core.rmem_max" = 268435456;
    "net.core.wmem_max" = 268435456;
    "net.ipv4.tcp_rmem" = "4096 65536 134217728";
    "net.ipv4.tcp_wmem" = "4096 65536 134217728";

    # Security
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
  };

  # Server-specific services
  services = {
    # Fail2ban for security
    fail2ban = {
      enable = true;
      maxretry = 5;
      ignoreIP = [ "127.0.0.1/8" "10.0.0.0/8" "192.168.0.0/16" ];
    };

    # Automatic system updates
    automatic-timers = true;
  };

  # Server firewall (more restrictive)
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ]; # Only SSH by default
    allowPing = false;
    logReversePathDrops = true;
  };

  # Server monitoring
  services.prometheus = {
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9100;
      };
    };
  };

  # Disable unnecessary services
  services = {
    xserver.enable = false;
    displayManager.sddm.enable = false;
    desktopManager.plasma6.enable = false;
    pulseaudio.enable = false;
    pipewire.enable = false;
    blueman.enable = false;
  };

  # Remove unnecessary packages
  environment.defaultPackages = [ ];
}
