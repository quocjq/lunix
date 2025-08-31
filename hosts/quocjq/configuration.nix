{ pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ./disko.nix ];
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
    extraLocaleSettings = {
      LC_ADDRESS = "vi_VN";
      LC_IDENTIFICATION = "vi_VN";
      LC_MEASUREMENT = "vi_VN";
      LC_MONETARY = "vi_VN";
      LC_NAME = "vi_VN";
      LC_NUMERIC = "vi_VN";
      LC_PAPER = "vi_VN";
      LC_TELEPHONE = "vi_VN";
      LC_TIME = "vi_VN";
    };
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
  ];
  # FIX: lua_ls, stylua in nixos can not load without this
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [ lua-language-server stylua ];

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

  services = {
    printing.enable = true; # Enable CUPS to print documents
    pulseaudio.enable = false;
    blueman.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
  security = {
    rtkit.enable = true;
    sudo.extraConfig = ''
      Defaults lecture = never # rollback results in sudo lectures after each reboot, it's somewhat useless anyway
      Defaults pwfeedback # password input feedback - makes typed password visible as asterisks
      Defaults timestamp_timeout=120 # only ask for password every 2h
      # Keep SSH_AUTH_SOCK so that pam_ssh_agent_auth.so can do its magic.
      Defaults env_keep+=SSH_AUTH_SOCK
    '';
  };
  programs.ssh.startAgent = true;
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
