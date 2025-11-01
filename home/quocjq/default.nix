{ username, ... }: {
  imports = [ ./common.nix ];

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";
  };

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 7d --keep 5";
    };
    flake = "/home/${username}/lunix";
  };
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;
}
