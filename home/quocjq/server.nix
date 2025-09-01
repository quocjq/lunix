# home/quocjq/server.nix
{ config, pkgs, inputs, ... }: {
  imports = [ ./common.nix ];

  # Server-specific packages (no GUI)
  home.packages = with pkgs; [
    # Server administration
    htop
    tmux
    screen

    # Network tools
    nmap
    netcat
    curl
    wget

    # System monitoring
    iotop
    iftop

    # Text editors (CLI only)
    vim
    nano
  ];

  # Remove GUI-related configurations for server
  xresources.properties = { }; # No X11 resources needed

  # Server-specific git configuration (might want different settings)
  programs.git = {
    enable = true;
    userName = "Bui Vinh Quoc";
    userEmail = "quocjq@gmail.com";
    extraConfig = {
      # Server-specific git settings
      init.defaultBranch = "main";
      core.editor = "vim";
    };
  };
}
