{ ... }:
{
  systemd.services.caelestia = {
    description = "Make caelestia a startscript";
    wantedBy = [ "multi-user.target" ]; # Ensures the service starts after basic system initialization
    script = ''
      caelestia shell -d
    '';
  };
}
