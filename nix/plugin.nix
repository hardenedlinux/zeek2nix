{ fetchFromGitHub
, fetchgit
, llvmPackages
, writeScript
, confdir
, PostgresqlPlugin
, KafkaPlugin
, zeekctl
, Http2Plugin
, SpicyPlugin
, SpicyAnalyzersPlugin
, Ikev2Plugin
, CommunityIdPlugin
, ZipPlugin
, PdfPlugin
, pkgs
, zeek-sources
, spicy-sources
}:
with pkgs;
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
    bash ${install_plugin} zeek-plugin-community-id ${zeek-sources.zeek-plugin-community-id.src}
  '' else "") +
  (if PdfPlugin then ''
      ##INSTALL ZEEK Plugins
    bash ${install_plugin} zeek-plugin-pdf ${zeek-sources.zeek-plugin-pdf.src}
  '' else "") +
  (if ZipPlugin then ''
      ##INSTALL ZEEK Plugins
    bash ${install_plugin} zeek-plugin-zip ${zeek-sources.zeek-plugin-zip.src}
  '' else "") +
  (if KafkaPlugin then ''
      ##INSTALL ZEEK Plugins
    bash ${install_plugin} zeek-plugin-kafka ${zeek-sources.zeek-plugin-kafka.src}
  '' else "") +
  (if Ikev2Plugin then ''
      ##INSTALL ZEEK Plugins
    bash ${install_plugin} zeek-plugin-ikev2 ${zeek-sources.zeek-plugin-ikev2.src}
  '' else "") +
  (if Http2Plugin then ''
      ##INSTALL ZEEK Plugins
    bash ${install_plugin} zeek-plugin-http2 ${zeek-sources.zeek-plugin-http2.src}
  '' else "") +
  (if SpicyPlugin then ''
    mkdir -p /build/spicy
    cp -r ${Spicy}/* /build/spicy
    chmod 755  /build/spicy/*
    patchShebangs /build/spicy/scripts/autogen-type-erased
    patchShebangs /build/spicy/scripts/autogen-dispatchers
    ${lib.optionalString SpicyAnalyzersPlugin
      ''bash ${install_plugin} spicy-analyzers ${zeek-sources.spicy-analyzers.src}
      substituteInPlace /build/spicy-analyzers/CMakeLists.txt \
      --replace "0.4" "0" \
      --replace "00400" "0"
      ''
     }
    bash ${install_plugin} spicy ${Spicy}
    for e in $(cd $out/bin && ls |  grep -E 'spicy|hilti' ); do
      wrapProgram $out/bin/$e \
        --set CLANG_PATH      "${llvmPackages.clang}/bin/clang" \
        --set CLANGPP_PATH    "${llvmPackages.clang}/bin/clang++" \
        --set LIBRARY_PATH    "${lib.makeLibraryPath [ flex bison python38 zlib glibc llvmPackages.libclang llvmPackages.libcxxabi llvmPackages.libcxx ]}"
     done
  '' else "") +
  (if PostgresqlPlugin then ''
    bash ${install_plugin} zeek-plugin-postgresql ${zeek-sources.zeek-plugin-postgresql.src}
  '' else "");
}
