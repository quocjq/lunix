{ inputs, ... }:
{
  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          ./lib.nix
          ./unstable.nix
          ./noctalia.nix
          ./caelestia.nix
        ];
        config = { };
      };
    };

}
