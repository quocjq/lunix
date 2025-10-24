# home-manager/quocjq/hosts/nixos.nix
{ ... }: {
  imports = [
    ../modules/programs/media/easyeffects.nix
    ../modules/programs/media/obs.nix
    ../modules/programs/media/sioyek.nix
    ../modules/programs/communication/nixcord.nix
  ];

}
