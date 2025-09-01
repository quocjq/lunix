{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ../../modules/nixos/kanata.nix
    ../../modules/nixos/syncthing.nix
  ];
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.quocjq = import ./home.nix;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable networking
  networking.networkmanager.enable = true;
  hardware.bluetooth = {
    enable = true; # enables support for Bluetooth
    powerOnBoot = true; # powers up the default Bluetooth controller on boot
  };

  # Default System config
  nixpkgs.config.allowUnfree = true;
  time.timeZone = "Asia/Ho_Chi_Minh";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      type = "fcitx5";
      enable = true;
      fcitx5.addons = with pkgs; [ fcitx5-bamboo ];
    };
  };
  nix.optimise.automatic = true;
  nix.optimise.dates = [ "17:45" ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 3d";
  };
  fonts = {
    packages = with pkgs; [
      noto-fonts-emoji
      noto-fonts-cjk-sans
      font-awesome
      material-icons
      nerd-fonts.jetbrains-mono
    ];
  };

  # Define users 
  users.users.quocjq = {
    isNormalUser = true;
    description = "quocjq";
    extraGroups = [ "networkmanager" "wheel" ];
    initialHashedPassword =
      "$y$j9T$X2ik9Zf6kggwV6DFf3N4S0$DekhCps26lVQqewf.Ex.u5FoDviKimmuTiVGe.OsyUC";
  };

  # Install packages.
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    python314
    nodejs_24
    fd
    wl-clipboard
    lua
    ffmpeg
    gnumake
    geogebra
    bat
    zoxide
    tmux-sessionizer
    typst
    just
    kdePackages.kdenlive
    gcc
    libreoffice-qt6-fresh
    neofetch
    caligula
    dconf
    quickshell
  ];
  # FIX: lua_ls, stylua in nixos can not load without this
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [ lua-language-server stylua ];

  programs.mtr.enable = true; # Dont know what it is

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
  };

  # Enable the KDE Plasma Desktop Environment.
  # NOTE: Will use plasma-manager in the future
  #  or change completely to tiling manager
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration # Comment out this line if you use KDE Connect
    kdepim-runtime # Unneeded if you use Thunderbird, etc.
    konsole # Comment out this line if you use KDE's default terminal app
    oxygen
    kate
    elisa
    ktexteditor
    ark
  ];

  services.printing.enable = true; # Enable CUPS to print documents
  services.pulseaudio.enable = false;
  services.blueman.enable = true;
  security.rtkit.enable = true;
  programs.ssh.startAgent = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services = {
    flatpak.enable = true; # Enable Flatpak
    openssh.enable = true;
  };
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  system.stateVersion = "25.05";
}
