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
  # NOTE: Canon driver needs libxml2 2.13.x, mentioned in the AUR
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
  version = "5.00-18";

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

  unpackPhase = ''
    tar xzf $src
    cd linux-UFRIILT-drv-v500-uken/64-bit_Driver/Debian
    dpkg-deb -x cnrdrvcups-ufr2lt-uk_5.00-1_amd64.deb extracted
    cd extracted
  '';

  dontBuild = true;

  installPhase = ''

  '';

  meta = with lib; {
    description = "Canon UFR II/LIPSLX Printer Driver for Linux";
    homepage = "https://www.canon-europe.com/";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
}
