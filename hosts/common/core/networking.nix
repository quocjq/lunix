# hosts/common/networking.nix
{ ... }: {
  # Enable networking
  networking.networkmanager.enable = true;
  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = [ "8.8.8.8" "8.8.4.4" ];
    fallbackDns = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
    dnsovertls = "true";
  };
  # Bluetooth configuration
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
}
