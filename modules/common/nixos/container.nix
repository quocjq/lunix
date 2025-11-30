{ pkgs, ... }:
{
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
      defaultNetwork.settings.dns_enabled = true;
    };

    oci-containers = {
      backend = "podman";
      containers = {
        portainer = {
          image = "portainer/portainer-ce:latest"; # Use the Community Edition image
          ports = [
            "9443:9443" # Secure UI port (recommended)
          ];
          volumes = [
            "/var/lib/portainer_data:/data" # Mount a persistent volume for data
            "/var/run/docker.sock:/var/run/docker.sock:ro" # Mount the Docker socket for management
          ];
          # Optional: ensure it starts on boot
          autoStart = true;
        };
      };
    };
  };
  environment.systemPackages = with pkgs; [
    podman-compose
  ];
}
