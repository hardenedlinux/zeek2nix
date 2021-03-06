{ stdenv
, fetchurl
, cmake
, flex
, bison
, openssl
, libpcap
, zlib
, file
, curl
, libmaxminddb
, gperftools
, python
, swig
, fetchpatch
, ncurses5
, caf
  ## Plugin dependencies
, pkgs
, rdkafka
, postgresql
, coreutils
, callPackage
, libnghttp2
, brotli
, python38
, llvmPackages_9
, which
, geoip
, ccache
, libzip
, podofo
, makeWrapper
, PostgresqlPlugin ? false
, KafkaPlugin ? false
, Http2Plugin ? false
, SpicyPlugin ? false
, Ikev2Plugin ? false
, CommunityIdPlugin ? false
, ZipPlugin ? false
, PdfPlugin ? false
, zeekctl ? true
, version ? "4.0.0"
}:
let
  preConfigure = (import ./script.nix { });

  pname = "zeek";
  confdir = "/var/lib/${pname}";

  plugin = callPackage ./plugin.nix {
    inherit confdir zeekctl
      PostgresqlPlugin ZipPlugin PdfPlugin CommunityIdPlugin KafkaPlugin Http2Plugin
      SpicyPlugin pkgs
      Ikev2Plugin;
  };
in
stdenv.mkDerivation rec {
  inherit pname version;
  src = fetchurl {
    url = "https://download.zeek.org/zeek-${version}.tar.gz";
    sha256 = "sha256-MV5Wa67u7WY91nh5jOCgiCk1ymvSKSyfT5nhl9EDA/w=";
  };

  configureFlags = [
    "--with-geoip=${geoip}"
  ];
  ##for spicy ccache
  HOME = ".";

  nativeBuildInputs = [ cmake flex bison file makeWrapper ]
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

  postInstall = ''
    for file in $out/share/zeek/base/frameworks/notice/actions/pp-alarms.zeek $out/share/zeek/base/frameworks/notice/main.zeek; do
      substituteInPlace $file \
         --replace "/bin/rm" "${coreutils}/bin/rm" \
         --replace "/bin/cat" "${coreutils}/bin/cat"
    done
    for file in $out/share/zeek/policy/misc/trim-trace-file.zeek $out/share/zeek/base/frameworks/logging/postprocessors/scp.zeek $out/share/zeek/base/frameworks/logging/postprocessors/sftp.zeek; do
      substituteInPlace $file --replace "/bin/rm" "${coreutils}/bin/rm"
    done
  '';

  inherit (plugin) postFixup;

  meta = with stdenv.lib; {
    description = "Powerful network analysis framework much different from a typical IDS";
    homepage = "https://www.zeek.org";
    license = licenses.bsd3;
    #GTrunSec
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
