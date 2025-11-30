# modules/nixos/services/cups.nix
{ pkgs, config, ... }:
{
  # Enable Podman
  virtualisation.podman = {
    enable = true;
    dockerCompat = true; # Create a 'docker' alias for podman
    defaultNetwork.settings.dns_enabled = true;
  };

  # Add your user to podman group
  users.users.quocjq.extraGroups = [ "podman" ];

  # Create systemd service for CUPS container
  systemd.services.cups-printer = {
    description = "CUPS Printer Service in Podman";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      ExecStartPre = [
        # Build custom image from Dockerfile
        "${pkgs.podman}/bin/podman build -t cups-canon /home/quocjq/lunix/resources/cups-printer"
        # Remove old container if exists
        "-${pkgs.podman}/bin/podman rm -f cups-printer"
      ];

      ExecStart = ''
        ${pkgs.podman}/bin/podman run -d \
          --name cups-printer \
          --privileged \
          -v /dev/bus/usb:/dev/bus/usb \
          -v cups-data:/etc/cups \
          -p 631:631 \
          cups-canon
      '';

      ExecStop = "${pkgs.podman}/bin/podman stop cups-printer";
    };
  };

  # Open firewall for CUPS web interface
  networking.firewall = {
    allowedTCPPorts = [ 631 ];
  };

  # Create a helper script for managing the printer
  environment.systemPackages = [
    (pkgs.writeScriptBin "cups-printer-manage" ''
      #!${pkgs.bash}/bin/bash

      case "$1" in
        restart)
          systemctl restart cups-printer
          ;;
        rebuild)
          echo "Rebuilding image..."
          ${pkgs.podman}/bin/podman build -t cups-canon /home/quocjq/lunix/resources/cups-printer
          systemctl restart cups-printer
          ;;
        logs)
          ${pkgs.podman}/bin/podman logs -f cups-printer
          ;;
        shell)
          ${pkgs.podman}/bin/podman exec -it cups-printer /bin/bash
          ;;
        status)
          systemctl status cups-printer
          ${pkgs.podman}/bin/podman ps -a | grep cups-printer
          ;;
        stop)
          systemctl stop cups-printer
          ;;
        start)
          systemctl start cups-printer
          ;;
        *)
          echo "Usage: cups-printer-manage {restart|start|stop|rebuild|logs|shell|status}"
          echo ""
          echo "Commands:"
          echo "  restart - Restart the CUPS container"
          echo "  start   - Start the CUPS container"
          echo "  stop    - Stop the CUPS container"
          echo "  rebuild - Rebuild the image and restart"
          echo "  logs    - View container logs"
          echo "  shell   - Open shell in container"
          echo "  status  - Show service and container status"
          echo ""
          echo "Web interface: http://localhost:631"
          ;;
      esac
    '')
  ];
}
