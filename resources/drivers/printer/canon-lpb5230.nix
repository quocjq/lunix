{ stdenv }:
stdenv.mkDerivation rec {
  name = "lpb6230";
  version = "1.0";

  src = ./.;

  installPhase = ''
    mkdir -p $out/share/cups/model/
    cp myprinter.ppd $out/share/cups/model/
    # If you need to patch the path to files outside the nix store, you can do it this way
    # (if the ppd also comes with executables you may need to also patch the executables)
    substituteInPlace $out/share/cups/model/myprinter.ppd \
      --replace "/usr/yourProgram/" "${yourProgram}/bin/yourProgram"
  '';
}
