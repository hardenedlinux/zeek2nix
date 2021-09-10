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

  spicyInZeek = runCommand "patchedSpicy"
    {
      inherit (spicy-sources.spicy-latest) src;
      buildInputs = [ python38 ];
    }
    ''
      cp -r $src $out
      chmod -R +rw $out
      cat <<EOF > $out/VERSION
      ${lib.removePrefix "v" spicy-sources.spicy-release.version}-dev
      EOF
      patchShebangs $out/scripts
    '';

  install_plugin = pkgs.writeShellScript "install_plugin.sh" (import ./install_plugin.nix {
    inherit linuxHeaders llvmPackages confDir;
  });

  pluginsScript = lib.concatStringsSep "\n" (map (f: "bash ${install_plugin} ${f} ${zeek-sources.${f}.src}") plugins);

  preFixup = (if zeekctl then ''
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
  '' else "") + (if checkPlugin "zeek-plugin-spicy" then ''
    ${install_plugin} spicy ${spicyInZeek}
  '' else "") + ''
    ${pluginsScript}
  '';
}
