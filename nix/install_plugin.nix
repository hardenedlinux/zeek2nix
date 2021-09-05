{ llvmPackages, linuxHeaders }:
''

install_plugin(){
    name=$1
    path=$2
    mkdir -p /build/$1
    cp -r $2/* /build/$1/
    cd /build/$name/

    if [[ $name == 'zeek-plugin-spicy' ]]; then
    export PATH="$out/bin:$PATH"
    mkdir build && cd build
    export NIX_CFLAGS_LINK="$NIX_CFLAGS_LINK -ldl"
    cmake -DCMAKE_CXX_COMPILER=${llvmPackages.clang}/bin/clang++ -DCMAKE_C_COMPILER=${llvmPackages.clang}/bin/clang -DCMAKE_INSTALL_PREFIX=$out .. && make -j $NIX_BUILD_CORES && make install
    # intenrel spicy plugin
    fi

    # if [ $name == 'zeek-plugin-kafka' ] || [ $name == 'zeek-plugin-ikev2' ]; then
    #   export PATH="$out/bin:$PATH"
    #   ./configure --zeek-dist=$ZEEK_SRC
    #   make -j $NIX_BUILD_CORES && make install
    # fi

    if [ $name == 'zeek-plugin-community-id' ]; then
    ./configure --zeek-dist=$ZEEK_SRC
    cd build
    make -j $NIX_BUILD_CORES && make install
    fi

    if [ $name == 'zeek-plugin-af_packet' ]; then
    ./configure --zeek-dist=$ZEEK_SRC --with-kernel=${linuxHeaders}
    cd build
    make -j $NIX_BUILD_CORES && make install
    fi

    if [ $name == 'zeek-plugin-postgresql' ] \
    || [ $name == 'zeek-plugin-http2' ] \
    || [ $name == 'zeek-plugin-zip' ] \
    || [ $name == 'zeek-plugin-kafka' ] \
    || [ $name == 'zeek-plugin-pdf' ]; then
    ./configure --zeek-dist=$ZEEK_SRC
    make -j $NIX_BUILD_CORES && make install
    fi

}

install_plugin $1 $2

''
