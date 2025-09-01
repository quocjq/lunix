# home/quocjq/default.nix
{ config, pkgs, inputs, hostName, ... }: {
  imports = [
    ./common.nix
    #
  ] ++ (
    # Import host-specific configuration if it exists
    if builtins.pathExists ./hosts/${hostName}.nix then
      [ ./hosts/${hostName}.nix ]
    else
      [ ]);

  home.username = "quocjq";
  home.homeDirectory = "/home/quocjq";
  home.stateVersion = "25.05";
}
