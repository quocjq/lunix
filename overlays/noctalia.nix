{ inputs, ... }:
final: prev: {
  noctalia = inputs.noctalia.packages.${final.system}.default;
}
