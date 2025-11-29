{ inputs, ... }:
{
  # flake.overlays = {
  #   default = final: prev: {
  #     unstable = import inputs.nixpkgs-unstable {
  #       system = final.system;
  #       config.allowUnfree = true;
  #     };
  #     noctalia = inputs.noctalia.packages.${final.system}.default;
  #     caelestia = inputs.caelestia-shell.packages.${final.system}.default;
  #     caelestia-with-cli = inputs.caelestia-shell.packages.${final.system}.with-cli;
  #   };
  # };

  # perSystem =
  #   { system, ... }:
  #   {
  #     _module.args.pkgs = import inputs.nixpkgs {
  #       inherit system;
  #       overlays = import ../overlaysi { inherit inputs; };
  #       config = {
  #         allowUnfree = true;
  #       };
  #     };
  #   };
}
