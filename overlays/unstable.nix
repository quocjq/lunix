{ inputs, ... }:
final: prev: {
  unstable = import inputs.nixpkgs-unstable {
    # FIXME: feel not right
    system = final.system;
    config.allowUnfree = true;
  };
}
