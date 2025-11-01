{ pkgs, ... }: {
  imports = [
    ../../modules/home/cli
    #
  ];

  home.packages = with pkgs; [ rustup lazygit nodejs_24 python314 typst ];
}
