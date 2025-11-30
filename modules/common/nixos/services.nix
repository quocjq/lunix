{ pkgs, ... }:
{
  # Printing
  # NOTE Use Podman as dont have to deal with printer driver in NixOS
  # services.printing = {
  #   enable = true;
  #   drivers = with pkgs; [
  #     cnijfilter2
  #     canon-cups-ufr2
  #     canon-capt
  #     cups-bjnp
  #     carps-cups
  #     gutenprint
  #     gutenprintBin
  #   ];
  # };
  # networking.firewall.enable = false;
  # environment.systemPackages = with pkgs; [
  #   system-config-printer
  # ];
  # audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Flatpak and SSH
  services = {
    flatpak.enable = true;
    openssh.enable = true;
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-hyprland
      ];
    };
  };

  # Flatpak repository setup
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };
}
