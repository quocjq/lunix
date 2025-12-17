{ inputs, ... }:
final: prev: {
  unstable = import inputs.nixpkgs-unstable {
    config.allowUnfree = true;
  };
}
