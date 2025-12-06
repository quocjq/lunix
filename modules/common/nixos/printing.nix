{ pkgs, ... }:
{
  # Printing
  services = {
    printing = {
      enable = true;
      drivers = with pkgs; [
        cnijfilter2
        canon-cups-ufr2
        canon-capt
        cups-bjnp
        carps-cups
        # FIXME Try to to package it myself but failed
        # cndrvcups-ufr2lt
      ];
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    ipp-usb.enable = true;
  };
  networking.firewall.enable = false;
  environment.systemPackages = with pkgs; [
    system-config-printer
    ipp-usb
  ];

}
