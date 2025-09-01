# Reminder that CUPS cpanel defaults to localhost:631

{ pkgs, ... }: {
  services.printing = {
    enable = true;
    drivers = [ ];
    #logging = "debug";
  };

}
