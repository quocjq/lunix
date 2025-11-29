{ config, pkgs, ... }:
{
  environment.variables = {
    "DOOMDIR" = "~/lunix/resources/doom/";
  };
}
