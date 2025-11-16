{ pkgs, ... }: {
  services.emacs = {
    enable = true;
    package =
      pkgs.emacs; # replace with emacs-gtk, or a version provided by the community overlay if desired.
    defaultEditor = true;
  };

  environment.systemPackages = with pkgs; [
    ## Emacs itself
    binutils # native-comp needs 'as', provided by this
    emacs # HEAD + native-comp

    ## Doom dependencies
    git
    ripgrep
    gnutls # for TLS connectivity

    ## Optional dependencies
    fd # faster projectile indexing
    imagemagick # for image-dired
    zstd # for undo-fu-session/undo-tree compression

    ## Module dependencies
    # :vterm
    emacsPackages.vterm
    # :email mu4e
    mu
    isync
    # :emacs dired +dirvish
    ffmpegthumbnailer
    mediainfo
    vips
    # :tools editorconfig
    editorconfig-core-c # per-project style config
    # :tools lookup & :lang org +roam
    sqlite
    # :lang cc
    clang-tools
    # :lang latex & :lang org (latex previews)
    texlive.combined.scheme-medium
    # :lang beancount
    unstable.beancount
    unstable.beanquery
    unstable.fava
    # :lang nix
    age

    ispell
    nixfmt-rfc-style
    shellcheck
  ];

  environment.variables.PATH = [ "$XDG_CONFIG_HOME/emacs/bin" ];
  fonts.packages = [ pkgs.nerd-fonts.symbols-only ];
}
