{ pkgs ? import <nixpkgs> {}}:
with pkgs.lib;
let
  flakeLock = (builtins.fromJSON (builtins.readFile ./flake.lock)).nodes;
  loadInput = { locked, ... }:
    assert locked.type == "github";
    builtins.fetchTarball {
      url = "https://github.com/${locked.owner}/${locked.repo}/archive/${locked.rev}.tar.gz";
      sha256 = locked.narHash;
    };

  srcDepsSet = (map loadInput [
    flakeLock.CVE-2020-16898
    flakeLock.zeek-known-hosts-with-dns
    flakeLock.dns-tunnels
    flakeLock.dns-axfr
    flakeLock.top-dns
    flakeLock.zeek-long-connections
    flakeLock.conn-burst
  ]);

in
pkgs.stdenv.mkDerivation rec {
  name = "zeek-scripts";
  phases = [ "installPhase" ];
  installPhase = ''
    for i in ${builtins.toString srcDepsSet}; do
    if [ -f $i/zkg.meta  ];then
    name=$(grep 'tags' $i/zkg.meta | awk '{ print $3, "-" $4 }' | sed -e 's/\,//g' | sed -e 's/\ //g')
    else
    name=$(grep 'tags' $i/bro-pkg.meta | awk '{ print $3, "-" $4 }' | sed -e 's/\,//g' | sed -e 's/\ //g')
    fi
    if [ ! -d  $out/$name ]; then
     mkdir -p $out/$name
     fi
     cp -r $i/* $out/$name;
     done
  '';
}
