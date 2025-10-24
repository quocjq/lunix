{ ... }: {
  imports = [
    ../../modules/home-manager/bash.nix
    ../../modules/home-manager/kitty.nix
    ../../modules/home-manager/tmux.nix
    ../../modules/home-manager/starship.nix
    ../../modules/home-manager/xdg.nix
    ../../modules/home-manager/git.nix
    ../../modules/home-manager/caelestia.nix
  ];

  home.username = "quocjq";
  home.homeDirectory = "/home/quocjq";
}
