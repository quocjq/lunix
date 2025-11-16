{ hostname, ... }:
{
  imports = [
    ./boot.nix
    ./networking.nix
    ./nix.nix
    ./users.nix
    ./env.nix
  ];

  networking.hostName = hostname;
  
  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  system.stateVersion = "25.05";
}
