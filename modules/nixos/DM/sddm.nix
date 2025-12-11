{
  pkgs,
  ...
}:
let
  sddm-astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "hyprland_kath";
    # themeConfig = {
    #   AccentColor = "#746385";
    #   FormPosition = "left";
    #
    #   ForceHideCompletePassword = true;
    # };
  };
in
{
  environment.systemPackages = [ sddm-astronaut ];

  services = {
    displayManager = {
      sddm = {
        wayland.enable = true;
        enable = true;
        package = pkgs.kdePackages.sddm;

        theme = "sddm-astronaut-theme";

        extraPackages = [ sddm-astronaut ];
      };
      autoLogin = {
        enable = true;
        user = "quocjq";
      };
    };
  };
}
