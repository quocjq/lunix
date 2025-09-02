# hosts/common/default.nix
{ config, pkgs, inputs, hostName, ... }: {
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

  # Home-manager configuration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.quocjq = import ../../home/quocjq;

    extraSpecialArgs = { inherit inputs hostName; };
  };

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # System state version
  system.stateVersion = "25.05";
}
