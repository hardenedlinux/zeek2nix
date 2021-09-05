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
, ncurses5
, caf
  ## Plugin dependencies
, pkgs
, rdkafka
, postgresql
, coreutils
, libnghttp2
, brotli
, python38
, llvmPackages
, libzip
, podofo
, linuxHeaders
, zeek-sources
, spicy-latest
, zeekctl ? true
, confDir ? "/var/lib/zeek"
, plugins ? [ ]
}@args:
let

  checkPlugin = v: (toString (lib.intersectLists [ "${v}" ] plugins)) == v;

  preConfigure = (import ./script.nix { });
  pname = "zeek";

  plugin = import ./plugin.nix {
    inherit
      plugins
      linuxHeaders
      llvmPackages
      confDir
      zeekctl
      checkPlugin
      args
      ;
  };
in
stdenv.mkDerivation rec {
  inherit (zeek-sources.zeek-release) src pname version;

  ##for spicy ccache
  HOME = ".";

  nativeBuildInputs = [ cmake flex bison file ]
    ++ lib.optionals (checkPlugin "zeek-plugin-spicy") [ python38 ]
    ++ lib.optionals (checkPlugin "zeek-plugin-af_packet")
    [ linuxHeaders ];

  buildInputs = [ openssl libpcap zlib curl libmaxminddb gperftools python38 swig caf ncurses5 ]
    ++ lib.optionals (checkPlugin "zeek-plugin-kafka")
    [ rdkafka ]
    ++ lib.optionals (checkPlugin "zeek-plugin-postgresql")
    [ postgresql ]
    ++ lib.optionals (checkPlugin "zeek-plugin-zip")
    [ libzip ]
    ++ lib.optionals (checkPlugin "zeek-plugin-pdf")
    [ podofo ]
    ++ lib.optionals (checkPlugin "zeek-plugin-http2")
    [ libnghttp2 brotli ]
    ++ lib.optionals (checkPlugin "zeek-plugin-spicy")
    [ spicy-latest ];

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

  preFixup = (if checkPlugin "zeek-plugin-spicy" then
    ''
      ln -s  ${spicy-latest}/bin/* $out/bin
    '' else "");

  inherit (plugin) postFixup;

  meta = with lib; {
    description = "Powerful network analysis framework much different from a typical IDS";
    homepage = "https://www.zeek.org";
    license = licenses.bsd3;
    #maintainers = with maintainers; [ gtrunsec ];
    platforms = platforms.unix;
  };
}
