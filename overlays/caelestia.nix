{ inputs, ... }:
final: prev: {
  caelestia = inputs.caelestia-shell.packages.${final.system}.default;
  caelestia-with-cli = inputs.caelestia-shell.packages.${final.system}.with-cli;
}
