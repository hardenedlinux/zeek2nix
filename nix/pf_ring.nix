{ stdenv
, lib
, bison
, fetchFromGitHub
, flex

, hiredis
, zeromq
}:

let
  version = "8.2.0";
in
stdenv.mkDerivation {
  name = "pf-ring-${version}";

  src = fetchFromGitHub {
    owner = "ntop";
    repo = "PF_RING";
    rev = version;
    sha256 = "sha256-vjsN91n3+yG7WfJt/6iG1SK6M8e/dXrhTVXsmS3lCiw=";
  };

  nativeBuildInputs = [
    bison
    flex
  ];

  buildInputs = [
    hiredis
    zeromq
  ];

  postPatch = ''
    sed -i 's, lex$, flex,' userland/nbpf/Makefile.in
  '';

  preConfigure = ''
    cd userland/lib
  '';

  configureFlags = [
    "--enable-redis"
    "--enable-zmq"
  ];

  postInstall = ''
    cp -r ../../kernel/linux "$out/include"
  '';

  meta = with lib; {};
}
