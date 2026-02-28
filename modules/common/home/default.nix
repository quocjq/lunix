{ username, pkgs, ... }:
{
  imports = [
    ./bash.nix
    ./git.nix
    ./starship.nix
    ./tmux.nix
    ./xdg.nix
  ];
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.banana-cursor;
    name = "Banana";
    size = 15;
  };
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
  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
  };
  services.dunst = {
    enable = true;
    settings = {
      global = {
        font = "Droid Sans 10";
        allow_markup = true;
        format = "<b>%s</b>\\n%b";
        # ... other settings
      };
    };
  };
  programs.home-manager.enable = true;
  # nixpkgs.config.allowUnfree = true;
}
