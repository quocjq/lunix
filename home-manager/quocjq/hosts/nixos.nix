# home-manager/quocjq/hosts/nixos.nix
{ config, ... }: {
  imports = [
    ../../../modules/home-manager/easyeffects.nix
    ../../../modules/home-manager/obs.nix
    ../../../modules/home-manager/sioyek.nix
    ../../../modules/home-manager/nixcord.nix
  ];

}
