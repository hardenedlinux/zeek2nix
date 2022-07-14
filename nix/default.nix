{
  stdenv,
  lib,
  fetchurl,
  cmake,
  flex,
  bison,
  openssl,
  libpcap,
  zlib,
  file,
  curl,
  libmaxminddb,
  gperftools,
  swig,
  ncurses5,
  caf,
  jemalloc,
  ## Plugin dependencies
  pkgs,
  rdkafka,
  postgresql,
  coreutils,
  libnghttp2,
  brotli,
  python3,
  llvmPackages,
  libzip,
  glibc,
  which,
  makeWrapper,
  git,
  podofo,
  linuxHeaders,
  zeek-sources,
  spicy-sources,
  zeekctl ? true,
  confDir ? "/var/lib/zeek",
  plugins ? [],
} @ args: let
  checkPlugin = v: (toString (lib.intersectLists ["${v}"] plugins)) == v;
  preConfigure = import ./script.nix {};
  pname = "zeek";
  plugin = import ./plugin.nix {
    inherit plugins linuxHeaders llvmPackages confDir zeekctl checkPlugin args;
  };
in
  stdenv.mkDerivation rec {
    inherit (zeek-sources.zeek-release) src pname version;
    ##for spicy ccache

    HOME = ".";

    nativeBuildInputs =
      [cmake flex bison file]
      ++ lib.optionals (checkPlugin "zeek-plugin-spicy") [python3]
      ++ lib.optionals (checkPlugin "zeek-plugin-af_packet") [linuxHeaders];

    buildInputs =
      [
        openssl
        libpcap
        zlib
        curl
        libmaxminddb
        gperftools
        python3
        swig
        caf
        ncurses5
        jemalloc
      ]
      ++ lib.optionals (checkPlugin "zeek-plugin-kafka") [rdkafka]
      ++ lib.optionals (checkPlugin "zeek-plugin-postgresql") [postgresql]
      ++ lib.optionals (checkPlugin "zeek-plugin-zip") [libzip]
      ++ lib.optionals (checkPlugin "zeek-plugin-pdf") [podofo]
      ++ lib.optionals (checkPlugin "zeek-plugin-http2") [libnghttp2 brotli]
      ++ lib.optionals (checkPlugin "zeek-plugin-spicy") [
        which
        llvmPackages.lld
        llvmPackages.clang-unwrapped
        llvmPackages.llvm
        git
        makeWrapper
      ];

    ZEEK_DIST = "${placeholder "out"}";

    inherit preConfigure;

    cmakeFlags =
      [
        "-DPYTHON_EXECUTABLE=${python3}/bin/python"
        "-DPYTHON_INCLUDE_DIR=${python3}/include"
        "-DPY_MOD_INSTALL_DIR=${placeholder "out"}/${python3.sitePackages}"
        "-DENABLE_PERFTOOLS=true"
        "-DINSTALL_AUX_TOOLS=true"
        "-DINSTALL_ZEEKCTL=true"
        "-DZEEK_ETC_INSTALL_DIR=${placeholder "out"}/etc"
      ]
      ++ [
        "-DENABLE_JEMALLOC=true"
        "-DUSE_PERFTOOLS_TCMALLOC=true"
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
    postFixup =
      if checkPlugin "zeek-plugin-spicy"
      then ''
        for e in $(cd $out/bin && ls |  grep -E 'spicy|hilti' ); do
          wrapProgram $out/bin/$e \
            --set CLANG_PATH      "${llvmPackages.clang}/bin/clang" \
            --set CLANGPP_PATH    "${llvmPackages.clang}/bin/clang++" \
            --set LIBRARY_PATH    "${
          lib.makeLibraryPath [
            flex
            bison
            python3
            zlib
            glibc
            llvmPackages.libclang
            llvmPackages.libcxxabi
            llvmPackages.libcxx
          ]
        }"
         done
      ''
      else "";
    inherit (plugin) preFixup;
    meta = with lib; {
      description = "Powerful network analysis framework much different from a typical IDS";
      homepage = "https://www.zeek.org";
      changelog = "https://github.com/zeek/zeek//blob/v${version}/CHANGELOG.md";
      license = with licenses; [bsd3];
      maintainers = with maintainers; [gtrunsec];
      platforms = platforms.unix;
    };
  }
