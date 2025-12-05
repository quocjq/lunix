{ pkgs, ... }:
{
  # Printing
  # NOTE Use Podman as dont have to deal with printer driver in NixOS
  services = {
    printing = {
      enable = true;
      drivers = with pkgs; [
        cnijfilter2
        canon-cups-ufr2
        canon-capt
        cups-bjnp
        carps-cups
      ];
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
      ipp-usb.enable = true;
    };

  };
  networking.firewall.enable = false;
  environment.systemPackages = with pkgs; [
    system-config-printer
  ];

}
