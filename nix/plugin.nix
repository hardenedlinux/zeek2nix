{ fetchFromGitHub
, fetchgit
, writeScript
, confdir
, PostgresqlPlugin
, KafkaPlugin
, zeekctl
, Http2Plugin
, SpicyPlugin
, Ikev2Plugin
, CommunityIdPlugin
, ZipPlugin
, PdfPlugin
, pkgs
}:
with pkgs;
let
  importJSON = file: builtins.fromJSON (builtins.readFile file);
  flakeLock = importJSON ../flake.lock;
  loadInput = { locked, ... }:
    assert locked.type == "git";
    fetchgit {
      url = "${locked.url}";
      rev = "${locked.rev}";
      sha256 = locked.narHash;
    };
in
rec {
  #import zeek script
  zeek-plugin-pdf = loadInput flakeLock.nodes.zeek-plugin-pdf;
  zeek-plugin-postgresql = loadInput flakeLock.nodes.zeek-plugin-postgresql;
  zeek-plugin-zip = loadInput flakeLock.nodes.zeek-plugin-zip;
  metron-zeek-plugin-kafka = loadInput flakeLock.nodes.metron-zeek-plugin-kafka;
  zeek-plugin-http2 = loadInput flakeLock.nodes.zeek-plugin-http2;
  zeek-plugin-ikev2 = loadInput flakeLock.nodes.zeek-plugin-ikev2;
  zeek-plugin-community-id = loadInput flakeLock.nodes.zeek-plugin-community-id;
  ##failed spicy plugin
  Spicy = runCommand "spciy-patch"
    {
      src = fetchFromGitHub (builtins.fromJSON (builtins.readFile ./zeek-plugin.json)).spicy;
      buildInputs = [ patchelf ];
    }
    ''
      mkdir -p $out
      cp -r $src/ patch-dir
      chmod -R +rw patch-dir
      patch < ${./version.patch} patch-dir/scripts/autogen-version
      cp -r patch-dir/. $out
    '';



  install_plugin = writeScript "install_plugin" (import ./install_plugin.nix {
    inherit llvmPackages;
  });

  postFixup = (if zeekctl then ''
    substituteInPlace $out/etc/zeekctl.cfg \
    --replace "CfgDir = $out/etc" "CfgDir = ${confdir}/etc" \
    --replace "SpoolDir = $out/spool" "SpoolDir = ${confdir}/spool" \
    --replace "LogDir = $out/logs" "LogDir = ${confdir}/logs"


    echo "scriptsdir = ${confdir}/scripts" >> $out/etc/zeekctl.cfg
    echo "helperdir = ${confdir}/scripts/helpers" >> $out/etc/zeekctl.cfg
    echo "postprocdir = ${confdir}/scripts/postprocessors" >> $out/etc/zeekctl.cfg
    echo "sitepolicypath = ${confdir}/policy" >> $out/etc/zeekctl.cfg
    ## default disable sendmail
    echo "sendmail=" >> $out/etc/zeekctl.cfg
  '' else "") +
  (if CommunityIdPlugin then ''
      ##INSTALL ZEEK Plugins
    bash ${install_plugin} zeek-plugin-community-id ${zeek-plugin-community-id}
  '' else "") +
  (if PdfPlugin then ''
      ##INSTALL ZEEK Plugins
    bash ${install_plugin} zeek-plugin-pdf ${zeek-plugin-pdf}
  '' else "") +
  (if ZipPlugin then ''
      ##INSTALL ZEEK Plugins
    bash ${install_plugin} zeek-plugin-zip ${zeek-plugin-zip}
  '' else "") +
  (if KafkaPlugin then ''
      ##INSTALL ZEEK Plugins
    bash ${install_plugin} metron-zeek-plugin-kafka ${metron-zeek-plugin-kafka}
  '' else "") +
  (if Ikev2Plugin then ''
      ##INSTALL ZEEK Plugins
    bash ${install_plugin} zeek-plugin-ikev2 ${zeek-plugin-ikev2}
  '' else "") +
  (if Http2Plugin then ''
      ##INSTALL ZEEK Plugins
    bash ${install_plugin} zeek-plugin-http2 ${zeek-plugin-http2}
  '' else "") +
  (if SpicyPlugin then ''
    mkdir -p /build/spicy
    cp -r ${Spicy}/* /build/spicy
    chmod 755  /build/spicy/*
    patchShebangs /build/spicy/scripts/autogen-type-erased
    patchShebangs /build/spicy/scripts/autogen-dispatchers
    bash ${install_plugin} spicy ${Spicy}
    for e in $(cd $out/bin && ls |  grep -E 'spicy|hilti' ); do
      wrapProgram $out/bin/$e \
        --set CLANG_PATH      "${llvmPackages.clang}/bin/clang" \
        --set CLANGPP_PATH    "${llvmPackages.clang}/bin/clang++" \
        --set LIBRARY_PATH    "${lib.makeLibraryPath [ flex bison python38 zlib glibc llvmPackages.libclang llvmPackages.libcxxabi llvmPackages.libcxx ]}"
     done
  '' else "") +
  (if PostgresqlPlugin then ''
    bash ${install_plugin} zeek-plugin-postgresql ${zeek-plugin-postgresql}
  '' else "");
}
