{ pkgs, ... }:
{
  imports = [
    ../../home/modules/cli
  ];

  home.packages = with pkgs; [
    rustup
    lazygit
    nodejs_24
    python314
    typst
  ];
}
