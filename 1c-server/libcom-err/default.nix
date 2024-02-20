{ stdenv, autoPatchelfHook, fetchurl, dpkg }:

stdenv.mkDerivation rec {
  pname = "libcom_err2";
  version = "1.47.0-2";

  src = fetchurl {
    url = "http://ftp.ru.debian.org/debian/pool/main/e/e2fsprogs/libcom-err2_${version}_amd64.deb";
    hash = "sha256-gBDkKFJ2uzRMBa54Deri//tF4jcRbDp4SBNlxZVBJew=";
  };

  nativeBuildInputs = [ dpkg autoPatchelfHook ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp lib/x86_64-linux-gnu/* $out/lib/
    
    runHook postInstall
  '';
}
