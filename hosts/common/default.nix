# hosts/common/default.nix
{ hostName, ... }: {
  imports = [
    ./bootloader.nix
    ./networking.nix
    ./system.nix
    ./users.nix
    ./programs.nix
    ./services.nix
  ];

  # Set the hostname dynamically
  networking.hostName = hostName;

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # System state version
  system.stateVersion = "25.05";
}
