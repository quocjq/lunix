# home-manager/quocjq/hosts/server.nix
{ pkgs, ... }: {
  # Server-specific configuration
  # You can add server-specific imports here
  # imports = [
  #   ../../../modules/home-manager/server-specific.nix
  # ];

  # Server-specific packages
  home.packages = with pkgs; [
    # Server monitoring and management
    htop
    iotop
    nethogs

    # Network tools
    nmap
    tcpdump

    # System administration
    rsync
    screen
  ];

  # Server-specific services or configurations
  # Disable GUI-related services for server
}
