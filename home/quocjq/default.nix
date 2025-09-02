{ config, inputs, hostName, ... }: {
  imports = [ ./common.nix ] ++ [ ./hosts/${hostName}.nix ];
  home.username = "quocjq";
  home.homeDirectory = "/home/quocjq";
  home.stateVersion = "25.05";
}
