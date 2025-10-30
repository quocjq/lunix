{ inputs }:
{
  generators = import ./generators.nix { inherit inputs; };
}
