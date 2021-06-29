{ llvmPackages }:
''

install_plugin(){
    if [ $name != 'spicy' ]; then
    name=$1
    path=$2
    mkdir -p /build/$1
    cp -r $2/* /build/$1/
    cd /build/$name/
    fi

    if [ $name == 'spicy' ]; then
    ./configure --with-zeek=$out --build-zeek-plugin=yes --generator=Ninja --prefix=$out --build-type=Release --with-cxx-compiler=${llvmPackages.clang}/bin/clang++ --with-c-compiler=${llvmPackages.clang}/bin/clang
    make -j $NIX_BUILD_CORES && make install
    # intenrel spicy plugin
    fi

    if [ $name == 'zeek-plugin-kafka' ] || [ $name == 'zeek-plugin-ikev2' ]; then
      export PATH="$out/bin:$PATH"
      ./configure --bro-dist=$ZEEK_SRC
      make -j $NIX_BUILD_CORES && make install
    fi

    if [ $name == 'zeek-plugin-community-id' ]; then
    ./configure --zeek-dist=$ZEEK_SRC
    cd build
    make -j $NIX_BUILD_CORES && make install
    fi

    if [ $name == 'zeek-plugin-postgresql' ] || [ $name == 'zeek-plugin-http2' ] || [ $name == 'zeek-plugin-zip' ] || [ $name == 'zeek-plugin-pdf' ]; then
    ./configure --zeek-dist=$ZEEK_SRC
    make -j $NIX_BUILD_CORES && make install
    fi

}

install_plugin $1 $2

''
