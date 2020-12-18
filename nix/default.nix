{ stdenv, fetchurl, cmake, flex, bison, openssl, libpcap, zlib, file, curl
, libmaxminddb, gperftools, python, swig, fetchpatch, ncurses5, caf
## Plugin dependencies
,  rdkafka, postgresql, coreutils
,  callPackage, libnghttp2, brotli, python38, llvmPackages_9, which, geoip, ccache
,  libzip, podofo
,  PostgresqlPlugin ? false
,  KafkaPlugin ? false
,  Http2Plugin ? false
,  SpicyPlugin ? false
,  Ikev2Plugin ? false
,  CommunityIdPlugin ? false
,  ZipPlugin ? false
,  PdfPlugin ? false
,  zeekctl ? true
,  version ? "3.2.3"
}:
let
  preConfigure = (import ./script.nix {inherit coreutils;});

  pname = "zeek";
  confdir = "/var/lib/${pname}";

  plugin = callPackage ./plugin.nix {
    inherit confdir zeekctl
      PostgresqlPlugin ZipPlugin PdfPlugin CommunityIdPlugin KafkaPlugin  Http2Plugin SpicyPlugin Ikev2Plugin;
  };
in
stdenv.mkDerivation rec {
  inherit pname version;
  src = fetchurl {
    url = "https://download.zeek.org/zeek-${version}.tar.gz";
    sha256 = "sha256-+SlcLdQHanEEK8g6JnsLDV1dspHXx6ErbFusdSkrwsY=";
  };

  configureFlags = [
    "--with-geoip=${geoip}"
  ];
  ##for spicy ccache
  HOME = ".";

  nativeBuildInputs = [ cmake flex bison file ]
                      ++ stdenv.lib.optionals SpicyPlugin [ python38 ];
  buildInputs = [ openssl libpcap zlib curl libmaxminddb gperftools python swig caf ncurses5 ]
                ++ stdenv.lib.optionals KafkaPlugin
                  [ rdkafka ]
                ++ stdenv.lib.optionals PostgresqlPlugin
                  [ postgresql ]
                ++ stdenv.lib.optionals ZipPlugin
                  [ libzip ]
                ++ stdenv.lib.optionals PdfPlugin
                  [ podofo ]
                ++ stdenv.lib.optionals Http2Plugin
                  [ libnghttp2 brotli ]
                ++ stdenv.lib.optionals SpicyPlugin
                  [ which ccache llvmPackages_9.lld llvmPackages_9.clang-unwrapped llvmPackages_9.llvm ];

  ZEEK_DIST = "${placeholder "out"}";
  #see issue https://github.com/zeek/zeek/issues/804 to modify hardlinking duplicate files.
  inherit preConfigure;

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DPYTHON_EXECUTABLE=${python}/bin/python"
    "-DPYTHON_INCLUDE_DIR=${python}/include"
    "-DPYTHON_LIBRARY=${python}/lib"
    "-DPY_MOD_INSTALL_DIR=${placeholder "out"}/${python.sitePackages}"
    "-DENABLE_PERFTOOLS=true"
    "-DINSTALL_AUX_TOOLS=true"
    "-DINSTALL_ZEEKCTL=true"
    "-DZEEK_ETC_INSTALL_DIR=${placeholder "out"}/etc"
  ];

  inherit (plugin) postFixup;

  meta = with stdenv.lib; {
    description = "Powerful network analysis framework much different from a typical IDS";
    homepage = "https://www.zeek.org";
    license = licenses.bsd3;
    maintainers = with maintainers; [ GTrunSec ];
    platforms = platforms.unix;
  };
}
