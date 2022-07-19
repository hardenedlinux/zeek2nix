{
  lib,
  clangStdenv,
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
  python3,
  swig,
  gettext,
  coreutils,
  ncurses,
  fetchFromGitHub,
  which,
  jemalloc,
  zeek-sources,
  ## optional features
  zeekctl ? true,
  configDir ? "/var/lib/zeek",
}:
clangStdenv.mkDerivation rec {
  inherit (zeek-sources.zeek-release) pname src version;

  nativeBuildInputs = [
    bison
    cmake
    file
    flex
  ];

  buildInputs =
    [
      curl
      gperftools
      libmaxminddb
      libpcap
      ncurses
      openssl
      python3
      swig
      zlib
      which
      jemalloc
    ]
    ++ lib.optionals clangStdenv.isDarwin [
      gettext
    ];

  postPatch = ''
    patchShebangs ./auxil/spicy/spicy/scripts
  '';

  cmakeFlags =
    [
      "-DZEEK_PYTHON_DIR=${placeholder "out"}/lib/${python3.libPrefix}/site-packages"
      "-DENABLE_PERFTOOLS=true"
      "-DINSTALL_AUX_TOOLS=true"
      "-DDISABLE_SPICY=true"
    ]
    ++ lib.optionals zeekctl [
      "-DINSTALL_ZEEKCTL=true"
      "-DZEEK_ETC_INSTALL_DIR=${placeholder "out"}/etc"
    ]
    ++ [
      ## performance options
      "-DENABLE_JEMALLOC=true"
      "-DUSE_PERFTOOLS_TCMALLOC=true"
    ];

  postInstall = ''
    for file in $out/share/zeek/base/frameworks/notice/actions/pp-alarms.zeek \
    $out/share/zeek/base/frameworks/notice/main.zeek; do
      substituteInPlace $file \
         --replace "/bin/rm" "${coreutils}/bin/rm" \
         --replace "/bin/cat" "${coreutils}/bin/cat"
    done
    for file in $out/share/zeek/policy/misc/trim-trace-file.zeek $out/share/zeek/base/frameworks/logging/postprocessors/scp.zeek $out/share/zeek/base/frameworks/logging/postprocessors/sftp.zeek; do
      substituteInPlace $file --replace "/bin/rm" "${coreutils}/bin/rm"
    done
    tar -czvf $out/include/zeek-dist.tar.gz .
  '';

  preFixup =
    lib.optionalString zeekctl ''
      sed -i 's|'$out'/|${configDir}/|' $out/etc/zeekctl.cfg
      sed -i 's|'$out'/|${configDir}/|' $out/share/zeek/base/misc/installation.zeek
      sed -i 's|/bin/echo|${coreutils}/bin/echo|' $out/lib/${python3.libPrefix}/site-packages/zeekctl/ZeekControl/ssh_runner.py

      echo "scriptsdir = ${configDir}/scripts" >> $out/etc/zeekctl.cfg
      echo "helperdir = ${configDir}/scripts/helpers" >> $out/etc/zeekctl.cfg
      echo "postprocdir = ${configDir}/scripts/postprocessors" >> $out/etc/zeekctl.cfg
      echo "sitepolicypath = ${configDir}/policy" >> $out/etc/zeekctl.cfg
      ## default disable sendmail
      echo "sendmail=" >> $out/etc/zeekctl.cfg
    ''
    + ''
      # Install the spicy manually.

      cd /build/source/auxil/spicy/spicy
      ./configure --prefix=$out --build-type=Release \
      --disable-precompiled-headers
      make -j $NIX_BUILD_CORES && make install

      export PATH="$out/bin:$PATH"
      cd /build/source/auxil/spicy-plugin
      mkdir build && cd build
      export NIX_CFLAGS_LINK="$NIX_CFLAGS_LINK -ldl"
      cmake -DZEEK_DEBUG_BUILD=yes \
      -DCMAKE_INSTALL_PREFIX=$out .. && make -j $NIX_BUILD_CORES \
       && cd .. && make -C build install
    '';

  meta = with lib; {
    description = "Network analysis framework much different from a typical IDS";
    homepage = "https://www.zeek.org";
    changelog = "https://github.com/zeek/zeek/blob/v${version}/CHANGES";
    license = licenses.bsd3;
    maintainers = with maintainers; [pSub marsam tobim];
    platforms = platforms.unix;
  };
}
