{ pkgs, ... }:
{
  services.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk; # replace with emacs-gtk, or a version provided by the community overlay if desired.
    defaultEditor = true;
  };

  environment.systemPackages = with pkgs; [
    ## Emacs itself
    binutils # native-comp needs 'as', provided by this
    emacs-pgtk # HEAD + native-comp

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
    libvterm
    libtool
    cmake
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
    texlivePackages.scheme-full
    texlivePackages.mylatexformat
    texlivePackages.dvipng
    texliveFull
    # :lang beancount
    unstable.beancount
    unstable.beanquery
    unstable.fava
    # :lang nix
    age
    nixfmt-rfc-style
    nil
    # :lang python
    black
    isort
    pipenv
    emacsPackages.flycheck-pyflakes

    ispell

    # :lang sh
    shellcheck
    shfmt
    # :lang org +roam
    graphviz
    gnuplot
    emacsPackages.gnuplot

    # Thesaurus
    emacsPackages.powerthesaurus

    # Emac-everywhere
    pandoc
    xdotool
    xorg.xwininfo
    xclip
    wlprop
    hyprprop
    xorg.xprop

  ];

  environment.variables.PATH = [ "~/.config/emacs/bin" ];
  fonts.packages = [ pkgs.nerd-fonts.symbols-only ];
}
