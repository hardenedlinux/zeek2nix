{ stdenv
, lib
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
, llvmPackages
, ninja
, which
, ccache
, libzip
, podofo
, makeWrapper
, git
, linuxHeaders
, postgresqlPlugin ? false
, kafkaPlugin ? false
, http2Plugin ? false
, spicyPlugin ? false
, ikev2Plugin ? false
, af_packetPlugin ? false
, communityIdPlugin ? false
, zipPlugin ? false
, pdfPlugin ? false
, zeekctl ? true
, zeek-sources
, spicy-sources
, confDir ? "/var/lib/zeek"
}@args:
let
  preConfigure = (import ./script.nix { });
  pname = "zeek";

  plugin = callPackage ./plugin.nix {
    inherit
      llvmPackages
      linuxHeaders
      confDir
      zeekctl
      af_packetPlugin
      postgresqlPlugin
      zipPlugin
      pdfPlugin
      communityIdPlugin
      kafkaPlugin
      http2Plugin
      spicyPlugin
      ikev2Plugin
      args;
  };
in
stdenv.mkDerivation rec {
  inherit (zeek-sources.zeek-release) src pname version;

  ##for spicy ccache
  HOME = ".";

  nativeBuildInputs = [ cmake flex bison file makeWrapper ]
    ++ lib.optionals spicyPlugin [ python38 ]
    ++ lib.optionals af_packetPlugin
    [ linuxHeaders ];

  buildInputs = [ openssl libpcap zlib curl libmaxminddb gperftools python38 swig caf ncurses5 ]
    ++ lib.optionals kafkaPlugin
    [ rdkafka ]
    ++ lib.optionals postgresqlPlugin
    [ postgresql ]
    ++ lib.optionals zipPlugin
    [ libzip ]
    ++ lib.optionals pdfPlugin
    [ podofo ]
    ++ lib.optionals http2Plugin
    [ libnghttp2 brotli ]
    ++ lib.optionals spicyPlugin
    [ which ccache llvmPackages.lld llvmPackages.clang-unwrapped llvmPackages.llvm ninja git ];

  ZEEK_DIST = "${placeholder "out"}";

  inherit preConfigure;

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DPYTHON_EXECUTABLE=${python38}/bin/python"
    "-DPYTHON_INCLUDE_DIR=${python38}/include"
    "-DPY_MOD_INSTALL_DIR=${placeholder "out"}/${python38.sitePackages}"
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
    #zeekctl
    for file in $out/lib/zeek/python/zeekctl/ZeekControl/ssh_runner.py; do
    substituteInPlace $file \
      --replace "/bin/echo" "${coreutils}/bin/echo"
    done
  '';

  inherit (plugin) postFixup;

  meta = with lib;
    {
      description = "Powerful network analysis framework much different from a typical IDS";
      homepage = "https://www.zeek.org";
      license = licenses.bsd3;
      #maintainers = with maintainers; [ gtrunsec ];
      platforms = platforms.unix;
    };
}
