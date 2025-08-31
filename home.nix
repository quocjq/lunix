{ config, pkgs, ... }: {
  imports = [
    ./modules/home-manager/waybar.nix
    # ./modules/home-manager/hypr 
  ];

  home.username = "quocjq";
  home.homeDirectory = "/home/quocjq";

  home.file.".config/nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/Lunix/home/nvim";
    recursive = true;
  };

  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };

  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps = { enable = true; };
    portal = {
      enable = true;
      config.common.default = "*";
      extraPortals = [
        pkgs.kdePackages.xdg-desktop-portal-kde # Replace with your compositor's package
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal
      ];
    };
  };

  services.easyeffects = {
    enable = true;
    preset = "default";
    extraPresets = {
      default = {
        input = {
          blocklist = [ ];
          "plugins_order" = [ "rnnoise#0" ];
          "rnnoise#0" = {
            bypass = false;
            "enable-vad" = false;
            "input-gain" = 0.0;
            "model-path" = "";
            "output-gain" = 0.0;
            release = 20.0;
            "vad-thres" = 50.0;
            wet = 0.0;
          };
        };
      };
    };
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    nix-output-monitor
    nh
    nvd
    zip
    xz
    unzip
    p7zip
    zstd
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder
    dnsutils # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    tree
    gnutar
    gnupg
    btop # replacement of htop/nmon
    lsof # list open files
    sysstat
    pciutils # lspci
    usbutils # lsusb
    neovim
    mpv
    rustup
    lazygit
    firefox
    swww
    waypaper
    pavucontrol
    easyeffects
  ];

  programs.git = {
    enable = true;
    userName = "Bui Vinh Quoc";
    userEmail = "quocjq@gmail.com";
  };

  programs.starship = {
    enable = true;
    settings = {
      scan_timeout = 2;
      command_timeout = 2000;
      add_newline = false;
      line_break.disabled = false;

      character = {
        success_symbol = "[›](bold green)";
        error_symbol = "[›](bold red)";
      };
      git_status = {
        deleted = "✗";
        modified = "✶";
        staged = "✓";
        stashed = "≡";
      };
      hostname = {
        ssh_only = true;
        disabled = false;
        format = "[$hostname](bold blue) ";
      };
      directory = {
        truncation_length = 2;
        read_only = "  ";
      };
      lua.symbol = "[ ](blue) ";
      python.symbol = "[ ](blue) ";
      rust.symbol = "[ ](red) ";
      nix_shell.symbol = "[󱄅 ](blue) ";
      golang.symbol = "[󰟓 ](blue)";
      c.symbol = "[ ](black)";
      nodejs.symbol = "[󰎙 ](yellow)";

      package.symbol = " ";
    };
  };

  programs.kitty = {
    enable = true;
    themeFile = "OneDark";
    actionAliases = { };
    settings = {
      allow_remote_control = true;
      confirm_os_window_close = 0;
      cursor_trail = 1;
      cursor_trail_start_threshold = 2;
      remember_window_size = true;
    };
  };

  programs.tmux = {
    enable = true;
    baseIndex = 1;
    escapeTime = 0;
    mouse = true;
    keyMode = "vi";
    terminal = "screen-256color";
    extraConfig = ''
      set -g prefix M-a
      set -g set-clipboard on
      set -g status-position top
      set -g renumber-windows on
      set -g history-limit 1000000
      set -g escape-time 0
      set -g status-right-length 100
      set -g status-left-length 100
      bind -n M-R source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"
      bind C-p previous-window
      bind C-n next-window
      bind -n M-F new-window -c ~/Lunix/ "nvim flake.nix"
      bind -n M-o new-window -c ~/ "tms"
      bind -n M-f new-window -c ~/ "nvim $(fzf)"
      bind -n M-g new-window -c ~/Lunix/ "lazygit" 
      bind -n M-c kill-pane
      bind -n M-q kill-window
      bind -n M-D kill-session -a
    '';
    plugins = with pkgs.tmuxPlugins; [
      nord
      sensible
      yank
      tilish
      tmux-fzf
      {
        plugin = resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '10'
          set -g @continuum-boot 'on'
        '';
      }
      {
        plugin = fzf-tmux-url;
        extraConfig = ''
          set -g @fzf-url-fzf-options '-p 60%,30% --prompt="   " --border-label=" Open URL "'
          set -g @fzf-url-history-limit '2000'
        '';
      }
    ];

  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      export EDITOR="e"
      alias f="ranger"
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
      alias rebuilds="sudo nixos-rebuild switch --flake ~/Lunix"
      alias opt="sudo nix store optimise"
      alias clean="sudo nh clean all --ask --keep 5"
      alias rebuild="nh os switch ~/Lunix"
      alias buildtest="nh os switch --dry ~/Lunix"
      alias e="nvim"
      alias search="nh search"
      alias la="eza -a"
      alias ll="eza -l"
    '';
    shellAliases = { };
  };

  programs.sioyek = {
    enable = true;
    bindings = {
      "move_up" = "k";
      "move_down" = "j";
      "move_left" = "h";
      "move_right" = "l";
      "screen_down" = "<C-d>";
      "screen_up" = "<C-u>";
      "fit_to_page_width_smart" = "zz";
      "add_highlight" = "H";
      "keyboard_smart_jump" = "F";
      "open_prev_doc" = "r";
      "search" = "/";
      "add_bookmark" = "m";
      "goto_bookmark" = "'";
      "goto_highlight" = "gh";
      "goto_bookmark_g" = "gB";
      "goto_highlight_g" = "gH";
      "copy" = "y";
      "keyboard_select" = "v";
      "delete_bookmark" = "db";
      "delete_highlight" = "dh";
      "next_item" = "<C-j>";
      "previous_item" = "<C-k>";
      "open_document_embedded" = "o";
      "open_document_embedded_from_current_path" = "O";
    };
    config = {
      "page_separator_width" = "2";
      "startup_commands" = "fit_to_page_width";
      "show_document_name_in_statusbar" = "1";

    };
  };

  programs.qutebrowser = {
    enable = true;
    extraConfig = "";
  };

  programs.ranger = { enable = true; };
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-pipewire-audio-capture
      obs-vkcapture
      obs-source-clone
      obs-move-transition
      obs-composite-blur
      obs-backgroundremoval
    ];
  };
  home.stateVersion = "25.05";
}
