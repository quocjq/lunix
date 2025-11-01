# home-manager/quocjq/hosts/nixos.nix
{ ... }: {
  imports = [
    ../../modules/home/programs/media/easyeffects.nix
    ../../modules/home/programs/media/obs.nix
    ../../modules/home/programs/media/sioyek.nix
    ../../modules/home/programs/communication/nixcord.nix
  ];

}
