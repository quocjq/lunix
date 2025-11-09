{ pkgs, ... }: {
  programs.firefox = {
    enable = true;

    languagePacks = [ "en-US" "de" "fr" ];

    preferences = { "privacy.resistFingerprinting" = true; };

    policies = { DisableTelemetry = true; };
  };
}
