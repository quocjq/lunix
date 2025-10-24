{ pkgs, inputs, ... }:
let spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in {
  imports = [ inputs.spicetify-nix.nixosModules.spicetify ];
  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      adblock
      keyboardShortcut
      showQueueDuration
      fullScreen
    ];
    enabledCustomApps = with spicePkgs.apps; [ marketplace lyricsPlus ];
    enabledSnippets = with spicePkgs.snippets; [
      rotatingCoverart
      pointer
      removeDuplicatedFullscreenButton
    ];

    theme = spicePkgs.themes.catppuccin;
    colorScheme = "macchiato";
  };
}
