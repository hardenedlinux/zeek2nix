{
  stdenv,
  cmake,
  python3,
  zlib,
  lib,
  zeek-sources,
  flex,
  bison,
}:
stdenv.mkDerivation {
  inherit (zeek-sources.zeek-release) pname version;

  src = zeek-sources.zeek-release.src + "/auxil/spicy/spicy";

  nativeBuildInputs = [
    flex
    cmake
    python3
  ];

  propagatedNativeBuildInputs = [ bison flex ];

  buildInputs = [zlib];

  postPatch = ''
    patchShebangs scripts tests
  '';

  cmakeFlags = [
    "-DHILTI_DEV_PRECOMPILE_HEADERS=OFF"
  ];

  meta = with lib; {
    description = "C++ parser generator for dissecting protocols & files";
    homepage = https://docs.zeek.org/projects/spicy/en/latest/;
    license = licenses.bsd3;
    platforms = with platforms; unix;
  };
}
