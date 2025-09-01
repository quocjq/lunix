# hosts/server/default.nix
{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    #
  ];

  # Server-specific packages (minimal GUI)
  environment.systemPackages = with pkgs; [
    # Server essentials
    htop
    tmux
    git
    curl
    # Add other server-specific packages
  ];

  # No GUI for server
  services = {
    xserver.enable = false;
    displayManager.sddm.enable = false;
    desktopManager.plasma6.enable = false;
  };

  # Server-specific services
  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    # Add other server services as needed
    nginx.enable = true;
    postgresql.enable = true;
  };

  # Server-specific modules
  imports = [
    ../../modules/nixos/server.nix
    #
  ];

  # Firewall configuration
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 80 443 ];
  };
}
