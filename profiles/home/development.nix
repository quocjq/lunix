{ pkgs, ... }: {
  imports = [
    ../../modules/home/common
    #
  ];

  home.packages = with pkgs; [ rustup lazygit nodejs_24 python314 typst ];
}
