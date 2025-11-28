{ inputs, ... }:
final: prev: {
  lib = inputs.nixpkgs.lib.extend (
    self: super: { custom = import ../lib { inherit (inputs.nixpkgs) lib; }; }
  );
}
