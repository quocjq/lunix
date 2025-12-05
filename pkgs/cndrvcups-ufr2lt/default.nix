{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  cups,
  gtk2,
  glib,
  gcc,
  libxml2,
  libjpeg,
  libgcrypt,
  gnome2,
  autoPatchelfHook,
  makeWrapper,
}:
let

  libxml2_13 = libxml2.overrideAttrs rec {
    version = "2.13.8";
    src = fetchurl {
      url = "mirror://gnome/sources/libxml2/${lib.versions.majorMinor version}/libxml2-${version}.tar.xz";
      hash = "sha256-J3KUyzMRmrcbK8gfL0Rem8lDW4k60VuyzSsOhZoO6Eo=";
    };
  };
in
stdenv.mkDerivation {
  pname = "cndrvcups-ufr2lt";
  version = "5.00.18";

  src = fetchurl {
    url = "http://gdlp01.c-wss.com/gds/0/0100005950/10/linux-UFRIILT-drv-v500-uken-18.tar.gz";
    sha256 = "0ngjj0iwhb9q78vmcdqmp1q3jfddyv9nzzd0jik0khbb05083226";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    cups
    gtk2
    glib
    gcc.cc.lib
    libxml2.out
    libxml2_13
    libjpeg
    libgcrypt
    gnome2.libglade
  ];

  # Explicitly tell autoPatchelfHook about runtime dependencies
  runtimeDependencies = [
    libxml2.out
    gnome2.libglade
  ];

  unpackPhase = ''
    tar xzf $src
    cd linux-UFRIILT-drv-v500-uken/64-bit_Driver/Debian

    # Extract the .deb package
    dpkg-deb -x cnrdrvcups-ufr2lt-uk_5.00-1_amd64.deb extracted
  '';

  dontBuild = true;

  installPhase = ''
    cd extracted

    # Copy everything to output
    mkdir -p $out
    cp -r usr/* $out/

    # Move libs from multiarch dir to standard lib dir
    if [ -d $out/lib/x86_64-linux-gnu ]; then
      mkdir -p $out/lib
      cp -r $out/lib/x86_64-linux-gnu/* $out/lib/
      rm -rf $out/lib/x86_64-linux-gnu
    fi

    # Create lib64 symlink for compatibility
    ln -s $out/lib $out/lib64

    # Ensure CUPS directories exist and are in the right place
    mkdir -p $out/lib/cups/filter
    mkdir -p $out/share/cups/model

    # Move filters if they're in libexec
    if [ -d $out/libexec/cups/filter ]; then
      cp -r $out/libexec/cups/filter/* $out/lib/cups/filter/
    fi

    # Move PPD files to correct location
    if [ -d $out/share/ppd ]; then
      cp -r $out/share/ppd/* $out/share/cups/model/
    fi

    # Make filters executable
    chmod +x $out/lib/cups/filter/* 2>/dev/null || true

    # Make binaries executable
    if [ -d $out/bin ]; then
      chmod +x $out/bin/* 2>/dev/null || true
    fi
  '';

  meta = with lib; {
    description = "Canon UFR II /LIPSLX Printer Driver for LBP112, LBP113, LBP151, LBP6030, LBP6230, LBP6320, LBP7110C, and LBP8100";
    homepage = "https://www.canon-europe.com/";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
}
