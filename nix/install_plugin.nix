{ llvmPackages }:
''

install_plugin(){
    name=$1
    path=$2
    mkdir -p /build/$1
    cp -r $2/* /build/$1/
    cd /build/$name/

    if [ $name == 'spicy' ] ; then
    mkdir -p /.ccache/tmp
    ./configure --with-zeek=$out --prefix=$out --build-type=Release --enable-ccache --with-cxx-compiler=${llvmPackages.clang}/bin/clang++ --with-c-compiler=${llvmPackages.clang}/bin/clang
    make -j $NIX_BUILD_CORES && make install
    fi

    if [ $name == 'spicy-analyzers' ] ; then
     mkdir build
     cd build
     cmake -DCMAKE_INSTALL_PREFIX=$out ..
     make -j $NIX_BUILD_CORES && make install
    fi

    if [ $name == 'metron-zeek-plugin-kafka' ] || [ $name == 'sasd' ]; then
        export PATH="$out/bin:$PATH"
        ./configure
         make -j $NIX_BUILD_CORES && make install
    fi

    if [ $name == 'zeek-plugin-ikev2' ]; then
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
