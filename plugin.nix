{ fetchFromGitHub, writeScript, version, confdir, PostgresqlPlugin, KafkaPlugin, zeekctl, Http2Plugin, SpicyPlugin, llvmPackages_9 }:
let
  flakeLock = builtins.importJSON ./flake.lock;
  loadInput = { locked, ... }:
    assert locked.type == "github";
    builtins.fetchTarball {
      url = "https://github.com/${locked.owner}/${locked.repo}/archive/${locked.rev}.tar.gz";
      sha256 = locked.narHash;
    };
in
rec {
  #import zeek script 
  zeek-postgresql = loadInput flakeLock.nodes.zeek-postgresql;
  metron-bro-plugin-kafka = loadInput flakeLock.nodes.metron-bro-plugin-kafka;
  bro-http2 =  loadInput flakeLock.nodes.bro-http2;
  zeek-plugin-ikev2 = loadInput flakeLock.nodes.zeek-plugin-ikev2;
  ##failed spicy plugin 
  Spicy = fetchFromGitHub (builtins.fromJSON (builtins.readFile ./zeek-plugin.json)).spicy;


  install_plugin = writeScript "install_plugin" (import ./install_plugin.nix { inherit llvmPackages_9; });
  postFixup =  (if zeekctl then ''
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
  (if KafkaPlugin then ''
         ##INSTALL ZEEK Plugins
       bash ${install_plugin} metron-bro-plugin-kafka ${metron-bro-plugin-kafka} ${version}
         '' else "") +
  (if Http2Plugin then ''
         ##INSTALL ZEEK Plugins
       bash ${install_plugin} bro-http2 ${bro-http2} ${version}
         '' else "") +
  (if SpicyPlugin then ''
    mkdir -p /build/spicy
    cp -r ${Spicy}/* /build/spicy
    chmod 755  /build/spicy/*
    patchShebangs /build/spicy/scripts/autogen-type-erased
    patchShebangs /build/spicy/scripts/autogen-dispatchers
    bash ${install_plugin} spicy ${Spicy} ${version}
            '' else "") +
  (if PostgresqlPlugin then ''
             bash ${install_plugin} zeek-postgresql ${zeek-postgresql} ${version}
    '' else "");
}
