# hosts/common/networking.nix
{ ... }: {
  # Enable networking
  networking.networkmanager.enable = true;

  # Bluetooth configuration
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
}
