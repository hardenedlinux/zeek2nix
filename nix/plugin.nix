{ args
, llvmPackages
, linuxHeaders
, postgresqlPlugin
, kafkaPlugin
, confDir
, zeekctl
, http2Plugin
, spicyPlugin
, ikev2Plugin
, af_packetPlugin
, communityIdPlugin
, zipPlugin
, pdfPlugin
}:
with args.pkgs;
rec {
  ##failed spicy plugin
  Spicy = runCommand "spciy-patch"
    {
      inherit (spicy-sources.spicy-release) src;
      buildInputs = [ patchelf ];
    }
    ''
      mkdir -p $out
      cp -r $src/ patch-dir
      chmod -R +rw patch-dir
      cp ${./VERSION} patch-dir/VERSION
      cp -r patch-dir/. $out
    '';

  install_plugin = pkgs.writeScript "install_plugin" (import ./install_plugin.nix {
    inherit llvmPackages linuxHeaders;
  });

  postFixup = (if zeekctl then ''
    substituteInPlace $out/etc/zeekctl.cfg \
    --replace "CfgDir = $out/etc" "CfgDir = ${confDir}/etc" \
    --replace "SpoolDir = $out/spool" "SpoolDir = ${confDir}/spool" \
    --replace "LogDir = $out/logs" "LogDir = ${confDir}/logs"


    echo "scriptsdir = ${confDir}/scripts" >> $out/etc/zeekctl.cfg
    echo "helperdir = ${confDir}/scripts/helpers" >> $out/etc/zeekctl.cfg
    echo "postprocdir = ${confDir}/scripts/postprocessors" >> $out/etc/zeekctl.cfg
    echo "sitepolicypath = ${confDir}/policy" >> $out/etc/zeekctl.cfg
    ## default disable sendmail
    echo "sendmail=" >> $out/etc/zeekctl.cfg
  '' else "") +
  (if communityIdPlugin then ''
      ##INSTALL ZEEK Plugins
    bash ${install_plugin} zeek-plugin-community-id ${zeek-sources.zeek-plugin-community-id.src}
  '' else "") +
  (if af_packetPlugin then ''
      ##INSTALL ZEEK Plugins

    bash ${install_plugin} zeek-plugin-af_packet ${zeek-sources.zeek-plugin-af_packet.src}
  '' else "") +
  (if pdfPlugin then ''
      ##INSTALL ZEEK Plugins
    bash ${install_plugin} zeek-plugin-pdf ${zeek-sources.zeek-plugin-pdf.src}
  '' else "") +
  (if zipPlugin then ''
      ##INSTALL ZEEK Plugins
    bash ${install_plugin} zeek-plugin-zip ${zeek-sources.zeek-plugin-zip.src}
  '' else "") +
  (if kafkaPlugin then ''
      ##INSTALL ZEEK Plugins
    bash ${install_plugin} zeek-plugin-kafka ${zeek-sources.zeek-plugin-kafka.src}
  '' else "") +
  (if ikev2Plugin then ''
      ##INSTALL ZEEK Plugins
    bash ${install_plugin} zeek-plugin-ikev2 ${zeek-sources.zeek-plugin-ikev2.src}
  '' else "") +
  (if http2Plugin then ''
      ##INSTALL ZEEK Plugins
    bash ${install_plugin} zeek-plugin-http2 ${zeek-sources.zeek-plugin-http2.src}
  '' else "") +
  (if spicyPlugin then ''
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
  (if postgresqlPlugin then ''
    bash ${install_plugin} zeek-plugin-postgresql ${zeek-sources.zeek-plugin-postgresql.src}
  '' else "");
}
