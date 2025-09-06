{ inputs, ... }: {
  imports = [ inputs.nixcord.homeModules.nixcord ];
  programs.nixcord = {
    enable = true; # Enable Nixcord (It also installs Discord)
    vesktop.enable = true; # Vesktop
    dorion.enable = true; # Dorion
    quickCss = ""; # quickCSS file
    config = {
      useQuickCss = true; # use out quickCSS
      autoUpdateNotification = false;
      autoUpdate = true;
      notifyAboutUpdates = false;
      transparent = true;
      frameless = true; # Set some Vencord options
      plugins = {
        USRBG.enable = true;
        alwaysExpandRoles.enable = true;
        betterFolders = {
          enable = true;
          closeAllFolders = true;
          closeAllHomeButton = true;
          closeOthers = true;
          forceOpen = true;
          sidebar = true;
        };
        fakeNitro = {
          enable = true;
          enableEmojiBypass = true;
          enableStickerBypass = true;
          enableStreamQualityBypass = true;
          disableEmbedPermissionCheck = true;
          transformEmojis = true;
          transformStickers = true;
        };
        shikiCodeblocks = {
          enable = true;
          useDevIcon = "COLOR";
        };
      };
    };
    extraConfig = {
      # Some extra JSON config here
      # ...
    };
  };
  # ...
}
