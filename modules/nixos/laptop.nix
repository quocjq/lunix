# modules/nixos/laptop.nix
{ config, pkgs, ... }: {
  # Power management for laptops
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 50;
    };
  };

  # Laptop-specific hardware
  hardware = {
    # Enable all firmware
    enableAllFirmware = true;

    # CPU microcode
    cpu.intel.updateMicrocode = true;
    # cpu.amd.updateMicrocode = true; # Uncomment if AMD
  };

  # Power management
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  # Backlight control
  programs.light.enable = true;

  # Laptop-specific services
  services = {
    # Auto-suspend when lid is closed
    logind = {
      lidSwitch = "suspend";
      lidSwitchExternalPower = "lock";
    };

    # Battery management
    upower.enable = true;
  };
}
