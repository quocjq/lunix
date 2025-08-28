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
      fira-code
      fira-code-symbols
      nerd-fonts.zed-mono
      nerd-fonts.ubuntu-sans
      nerd-fonts._0xproto
      nerd-fonts.agave
      nerd-fonts._3270
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
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services = {
    syncthing = {
      enable = true;
      group = "users";
      user = "quocjq";
      dataDir = "/home/quocjq/"; # Default folder for new synced folders
      configDir =
        "/home/quocjq/.config/syncthing"; # Folder for Syncthing's settings and keys
      guiAddress = "0.0.0.0:8384";
      settings = {
        gui = {
          user = "quocjq";
          password = "13172";
        };
        devices = {
          "RMX3085" = {
            id =
              "NLHOU3S-V7OCMQN-GRZJWI4-4LZJJRH-5JB6YKY-V5SWAO6-CYACWDR-CTJEBAN";
          };
        };
        folders = {
          "Storage" = {
            path = "~/Storage";
            devices = [ "RMX3085" ];
          };
        };
      };
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  programs.ssh.startAgent = true;

  services = {
    flatpak.enable = true; # Enable Flatpak
  };
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  services.kanata = {
    enable = true;
    keyboards = {
      internalKeyboard = {
        extraDefCfg = "process-unmapped-keys yes";
        config = ''
          (defsrc
          caps a s d f j k l ;
          )
          (defvar
           tap-time 200
           hold-time 200
          )
          (defalias
           a (tap-hold $tap-time $hold-time a lmet)
           s (tap-hold $tap-time $hold-time s lalt)
           d (tap-hold $tap-time $hold-time d lsft)
           f (tap-hold $tap-time $hold-time f lctl)
           j (tap-hold $tap-time $hold-time j rctl)
           k (tap-hold $tap-time $hold-time k rsft)
           l (tap-hold $tap-time $hold-time l lalt)
           ; (tap-hold $tap-time $hold-time ; rmet)
           caps esc
          )

          (deflayer base
           @caps @a  @s  @d  @f  @j  @k  @l  @;
          )
        '';
      };
    };
  };

  services.xserver.windowManager.qtile.enable = true;

  system.stateVersion = "25.05";
}
