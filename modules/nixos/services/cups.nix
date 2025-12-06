{ pkgs, ... }:
{
  # Enable Podman
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  # Add user to podman group
  users.users.quocjq.extraGroups = [ "podman" ];

  # Create systemd service for CUPS container
  systemd.services.cups-printer = {
    description = "CUPS Printer Service with Canon Driver in Podman";
    wantedBy = [ "multi-user.target" ];
    after = [
      "podman.service"
    ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      Type = "simple";
      RemainAfterExit = "no";
      Restart = "always";
      RestartSec = "10s";

      ExecStartPre = [
        # Remove old container if exists
        "-${pkgs.podman}/bin/podman rm -f cups-printer"
        # Build the image if Dockerfile exists
        "${pkgs.bash}/bin/bash -c 'if [ -f /home/quocjq/lunix/resources/cups-printer/Dockerfile ]; then ${pkgs.podman}/bin/podman build -t cups-printer /home/quocjq/lunix/resources/cups-printer; fi'"
      ];

      ExecStart = ''
        ${pkgs.podman}/bin/podman run --rm \
          --name cups-printer \
          --privileged \
          -v /dev/bus/usb:/dev/bus/usb \
          -v cups-printer-data:/etc/cups \
          -p 631:631 \
          cups-printer
      '';

      ExecStop = "${pkgs.podman}/bin/podman stop -t 10 cups-printer";
    };
  };

  # Open firewall for CUPS web interface
  networking.firewall = {
    allowedTCPPorts = [ 631 ];
  };

  # Create helper script for managing the printer
  environment.systemPackages = [
    (pkgs.writeScriptBin "cups-manage" ''
      #!${pkgs.bash}/bin/bash

      DOCKERFILE_PATH="/home/quocjq/lunix/resources/cups-printer"

      case "$1" in
        restart)
          echo "Restarting CUPS container..."
          systemctl restart cups-printer
          ;;
        rebuild)
          echo "Rebuilding image..."
          if [ -f "$DOCKERFILE_PATH/Dockerfile" ]; then
            ${pkgs.podman}/bin/podman build -t cups-printer "$DOCKERFILE_PATH"
            systemctl restart cups-printer
            echo "Done! Access CUPS at http://localhost:631"
          else
            echo "Error: Dockerfile not found at $DOCKERFILE_PATH/Dockerfile"
            exit 1
          fi
          ;;
        logs)
          ${pkgs.podman}/bin/podman logs -f cups-printer
          ;;
        shell)
          ${pkgs.podman}/bin/podman exec -it cups-printer /bin/bash
          ;;
        status)
          echo "=== Systemd Service Status ==="
          systemctl status cups-printer
          echo ""
          echo "=== Container Status ==="
          ${pkgs.podman}/bin/podman ps -a | grep cups-printer
          echo ""
          echo "=== CUPS Web Interface ==="
          echo "http://localhost:631"
          ;;
        stop)
          systemctl stop cups-printer
          ;;
        start)
          systemctl start cups-printer
          ;;
        clean)
          echo "Stopping and removing container..."
          systemctl stop cups-printer
          ${pkgs.podman}/bin/podman rm -f cups-printer 2>/dev/null || true
          echo "Removing image..."
          ${pkgs.podman}/bin/podman rmi cups-printer 2>/dev/null || true
          echo "Removing volume (this will delete printer configuration)..."
          read -p "Are you sure? (y/N) " -n 1 -r
          echo
          if [[ $REPLY =~ ^[Yy]$ ]]; then
            ${pkgs.podman}/bin/podman volume rm cups-printer-data 2>/dev/null || true
            echo "Cleaned up!"
          fi
          ;;
        *)
          echo "CUPS Printer Container Management"
          echo ""
          echo "Usage: cups-manage {command}"
          echo ""
          echo "Commands:"
          echo "  start    - Start the CUPS container"
          echo "  stop     - Stop the CUPS container"
          echo "  restart  - Restart the CUPS container"
          echo "  rebuild  - Rebuild the image from Dockerfile and restart"
          echo "  logs     - View container logs (Ctrl+C to exit)"
          echo "  shell    - Open shell in container"
          echo "  status   - Show service and container status"
          echo "  clean    - Remove container, image, and data volume"
          echo ""
          echo "CUPS Web Interface: http://localhost:631"
          echo "Default credentials: cups / cups"
          echo ""
          echo "Dockerfile location: $DOCKERFILE_PATH/Dockerfile"
          ;;
      esac
    '')
  ];
}
