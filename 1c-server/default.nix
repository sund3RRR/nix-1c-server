{ stdenv, dpkg, autoPatchelfHook, libkrb5, gss, unixODBC, corefonts, callPackage }:
let
  libcom-err2 = callPackage ./libcom-err { };
in
stdenv.mkDerivation rec {
  pname = "1c-server-package";
  version = "8.3.24.1439";

  src = ./src;

  unpackPhase = ''
    for file in $src/*.deb; do
      echo "$file"
      if [[ "$file" == *"${version}-server"* || "$file" == *"${version}-common"* ]]; then
          echo "Unpacking source archive: $file"
          dpkg-deb -x "$file" .
      fi
    done
  '';

  nativeBuildInputs = [ dpkg autoPatchelfHook ];
  buildInputs = [ libkrb5 gss unixODBC corefonts libcom-err2 ];

  installPhase = ''
    mkdir $out
    cp -r ./opt $out
    cp -r ./usr/share $out
  '';
}
