{ args
, linuxHeaders
, llvmPackages
, confDir
, zeekctl
, plugins
, checkPlugin
}:
with args.pkgs;
rec {
  install_plugin = pkgs.writeScript "install_plugin" (import ./install_plugin.nix {
    inherit linuxHeaders llvmPackages;
  });

  pluginsScript = lib.concatStringsSep "\n" (map (f: "bash ${install_plugin} ${f} ${zeek-sources.${f}.src}") plugins);

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
  '' else "") + ''
    ${pluginsScript}
  '';
}
