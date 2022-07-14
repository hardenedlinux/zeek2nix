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
}:
clangStdenv.mkDerivation rec {
  pname = "zeek";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "zeek";
    repo = "zeek";
    rev = "10d62ec132c95f4683e8c89e8ab1c31853eecc08";
    sha256 = "sha256-hcoqO3ey4zr6onOZET9ZANpZnNNpU/hAZSvFLE+l06s=";
    fetchSubmodules = true;
  };
  # src = fetchurl {
  #   url = "https://download.zeek.org/zeek-${version}.tar.gz";
  #   sha256 = "sha256-0NMA/Y2aGkhaAZjFLpdz23xTKCD6rqeX5MY6r6xj/X4=";
  # };

  patches = [];

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
    ]
    ++ lib.optionals clangStdenv.isDarwin [
      gettext
    ];

  postPatch = ''
    patchShebangs ./auxil/spicy/spicy/scripts
  '';

  cmakeFlags = [
    "-DZEEK_PYTHON_DIR=${placeholder "out"}/lib/${python3.libPrefix}/site-packages"
    "-DENABLE_PERFTOOLS=true"
    "-DINSTALL_AUX_TOOLS=true"
    "-DDISABLE_SPICY=true"
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
    tar -czvf $out/include/zeek-dist.tar.gz .
  '';

  preFixup = ''
    cd /build/source/auxil/spicy/spicy
    ./configure --prefix=$out --build-type=Release \
    --disable-precompiled-headers
    make -j $NIX_BUILD_CORES && make install

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
