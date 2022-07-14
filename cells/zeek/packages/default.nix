{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  in rec {

  zeek = inputs.nixpkgs.callPackage ./zeek.nix {};
  zeek-fix = inputs.nixpkgs.callPackage ({runCommand}: with nixpkgs; runCommand "zeek-fix" {
    buildInputs = [nixpkgs.makeWrapper];
  } ''
  mkdir -p $out
  for e in $(cd ${zeek}/bin && ls |  grep -E 'spicyz' ); do
      makeWrapper ${zeek}/bin/$e $out/bin/$e \
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
                libpcap
              ]
    }"
     done
  '') {};
}
